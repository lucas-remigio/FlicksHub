//
//  MovieDetailViewModel.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 10/10/2024.
//

import FirebaseFirestore
import FirebaseAuth

class FavoritesViewModel: ObservableObject {
    @Published var userPlaylists: [Playlist] = []  // Stores fetched playlists locally
    @Published var movies: [MovieDetail] = []  // Stores movie details for the current playlist
    
    // Fetch movies based on their IDs
    func fetchMovies(for movieIds: [Int], completion: @escaping () -> Void) {
        self.movies = []  // Clear movies list to show loading state
        let group = DispatchGroup()
        
        var fetchedMovies: [MovieDetail] = []
        
        for movieId in movieIds {
            group.enter()
            APICaller.getMovieDetailsById(movieId: movieId) { result in
                defer { group.leave() }
                
                switch result {
                case .success(let movieDetail):
                    fetchedMovies.append(movieDetail) // Assume Movie can be initialized from MovieDetail
                case .failure(let error):
                    print("Failed to fetch movie \(movieId): \(error)")
                }
            }
        }
        
        group.notify(queue: .main) {
            self.movies = fetchedMovies
            completion()  // Notify that fetching is complete
        }
    }
    
    func createPlaylist(name: String) async -> (Bool, String?, String?) {
        // Fetch playlists if empty
        if userPlaylists.isEmpty {
            do {
                userPlaylists = try await fetchUserPlaylistsAsync()
            } catch {
                print("Failed to fetch playlists: \(error.localizedDescription)")
                return (false, "Failed to fetch playlists", nil)
            }
        }

        // Validate the playlist name
        let validationResult = await validatePlaylistName(name)
        if !validationResult.isValid {
            return (false, validationResult.errorMessage, nil)
        }

        // Get current user ID
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in.")
            return (false, "User is not logged in", nil)
        }

        // Check for duplicate after fetching
        if userPlaylists.contains(where: { $0.name.lowercased() == name.lowercased() }) {
            print("A playlist with this name already exists.")
            return (false, "A playlist with this name already exists.", nil)
        }

        // Proceed with playlist creation
        do {
            let playlistId = try await performPlaylistCreation(name: name, userId: userId)
            return (true, nil, playlistId)
        } catch {
            print("Failed to create playlist: \(error.localizedDescription)")
            return (false, "Failed to create playlist", nil)
        }
    }

    private func performPlaylistCreation(name: String, userId: String) async throws -> String {
        let db = Firestore.firestore()
        let playlistRef = db.collection("playlists").document()

        let data: [String: Any] = [
            "userId": userId,
            "name": name,
            "movies": []
        ]
        
        // Set data asynchronously
        try await playlistRef.setData(data)
        
        // Optionally, add the new playlist to the local list
        self.userPlaylists.append(
            Playlist(
                id: playlistRef.documentID,
                userId: userId,
                name: name,
                movies: []
            )
        )
        
        return playlistRef.documentID
    }
    
    func addMovieToPlaylist(playlistId: String, movieId: Int) async -> Bool {
        let db = Firestore.firestore()
        let playlistRef = db.collection("playlists").document(playlistId)
        
        do {
            try await playlistRef.updateData([
                "movies": FieldValue.arrayUnion([movieId])
            ])
            print("Movie ID \(movieId) added to playlist \(playlistId).")
            return true
        } catch {
            print("Failed to add movie to playlist: \(error.localizedDescription)")
            return false
        }
    }
    
    func fetchUserPlaylists(completion: @escaping ([Playlist]?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in.")
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        db.collection("playlists")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Failed to fetch playlists: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    let playlists = snapshot?.documents.compactMap { doc -> Playlist? in
                        try? doc.data(as: Playlist.self)
                    }
                    self.userPlaylists = playlists ?? []
                    completion(playlists)
                }
            }
    }
    
    func fetchUserPlaylistsAsync() async throws -> [Playlist] {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])
        }

        let db = Firestore.firestore()
        
        // Use the new async Firestore API or wrap the current API in a CheckedContinuation
        let querySnapshot = try await db.collection("playlists")
            .whereField("userId", isEqualTo: userId)
            .getDocuments()

        let playlists = querySnapshot.documents.compactMap { doc -> Playlist? in
            try? doc.data(as: Playlist.self)
        }
        
        // Update local cache if needed
        self.userPlaylists = playlists
        
        return playlists
    }
    
    func removeMovieFromPlaylist(playlistId: String, movieId: Int, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let playlistRef = db.collection("playlists").document(playlistId)
        
        playlistRef.updateData([
            "movies": FieldValue.arrayRemove([movieId])
        ]) { error in
            if let error = error {
                print("Failed to remove movie from playlist: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Movie ID \(movieId) removed from playlist \(playlistId).")
                completion(true)
            }
        }
    }
    
    func deletePlaylist(playlistId: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let playlistRef = db.collection("playlists").document(playlistId)
        
        playlistRef.delete { error in
            if let error = error {
                print("Failed to delete playlist: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Playlist deleted successfully with ID \(playlistId)")
                // Remove the deleted playlist from the local array
                self.userPlaylists.removeAll { $0.id == playlistId }
                completion(true)
            }
        }
    }
    
    func editPlaylistName(playlistId: String, newName: String) async -> (Bool, String?) {
        // Validate the playlist name asynchronously
        let validationResult = await validatePlaylistName(newName)

        // If validation fails, return the error
        if !validationResult.isValid {
            return (false, validationResult.errorMessage)
        }
        
        let db = Firestore.firestore()
        let playlistRef = db.collection("playlists").document(playlistId)

        do {
            // Attempt to update the playlist name in Firestore
            try await playlistRef.updateData(["name": newName])
            print("Playlist name updated successfully.")
            
            // Update the local playlist array
            if let index = self.userPlaylists.firstIndex(where: { $0.id == playlistId }) {
                self.userPlaylists[index].name = newName
            }
            return (true, nil)
        } catch {
            // Handle any errors from Firestore
            print("Failed to edit playlist name: \(error.localizedDescription)")
            return (false, "Error editing playlist name.")
        }
    }
    
    func validatePlaylistName(_ name: String) async -> (isValid: Bool, errorMessage: String?) {
        // Check if the name is empty
        if name.isEmpty {
            return (false, "Please enter a playlist name")
        }

        // Check if the name is too long
        if name.count > 25 {
            return (false, "Playlist name is too long")
        }

        // Check if the name is too short
        if name.count < 3 {
            return (false, "Playlist name is too short")
        }

        // Trim leading and trailing whitespaces and check if the name is empty
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedName.isEmpty {
            return (false, "Playlist name cannot be just spaces")
        }

        // Fetch playlists if userPlaylists is empty
        if self.userPlaylists.isEmpty {
            do {
                self.userPlaylists = try await fetchUserPlaylistsAsync()
            } catch {
                return (false, "Failed to fetch playlists: \(error.localizedDescription)")
            }
        }

        // Check for duplicate names (case insensitive)
        if userPlaylists.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) {
            return (false, "A playlist with this name already exists")
        }

        // Limit the number of playlists a user can create
        if userPlaylists.count >= 100 {
            return (false, "You have reached the maximum number of playlists")
        }

        // Check for sequential spaces in the name
        if trimmedName.contains("  ") {
            return (false, "Playlist name cannot contain sequential spaces")
        }

        // If all validations pass, return true
        return (true, nil)
    }
}
