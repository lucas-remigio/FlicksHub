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
    
    func createPlaylist(name: String, completion: @escaping (Bool, String?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in.")
            completion(false, nil)
            return
        }

        // If userPlaylists is empty, fetch playlists before creating
        if userPlaylists.isEmpty {
            fetchUserPlaylists { [weak self] fetchedPlaylists in
                guard let self = self else { return }
                
                self.userPlaylists = fetchedPlaylists ?? []

                // Check for duplicate after fetching
                if self.userPlaylists.contains(where: { $0.name == name }) {
                    print("A playlist with this name already exists.")
                    completion(false, nil)
                } else {
                    // No duplicate found, proceed with playlist creation
                    self.performPlaylistCreation(name: name, userId: userId, completion: completion)
                }
            }
        } else {
            // Check for duplicate in already fetched playlists
            if userPlaylists.contains(where: { $0.name == name }) {
                print("A playlist with this name already exists.")
                completion(false, nil)
            } else {
                performPlaylistCreation(name: name, userId: userId, completion: completion)
            }
        }
    }

    // Helper method to perform the actual creation once checks are complete
    private func performPlaylistCreation(name: String, userId: String, completion: @escaping (Bool, String?) -> Void) {
        let db = Firestore.firestore()
        let playlistRef = db.collection("playlists").document()

        let data: [String: Any] = [
            "userId": userId,
            "name": name,
            "movies": []
        ]

        playlistRef.setData(data) { error in
            if let error = error {
                print("Failed to create playlist: \(error.localizedDescription)")
                completion(false, nil)
            } else {
                print("Playlist created successfully with ID \(playlistRef.documentID)")
                // Optionally, add the new playlist to the local list
                self.userPlaylists
                    .append(
                        Playlist(
                            id: playlistRef.documentID,
                            userId: Auth.auth().currentUser?.uid ?? "",
                            name: name,
                            movies: []
                        )
                    )
                completion(true, playlistRef.documentID)
            }
        }
    }
    
    func addMovieToPlaylist(playlistId: String, movieId: Int, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let playlistRef = db.collection("playlists").document(playlistId)
        
        playlistRef.updateData([
            "movies": FieldValue.arrayUnion([movieId])
        ]) { error in
            if let error = error {
                print("Failed to add movie to playlist: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Movie ID \(movieId) added to playlist \(playlistId).")
                completion(true)
            }
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
    
    func editPlaylistName(playlistId: String, newName: String, completion: @escaping (Bool) -> Void)
    {
        let db = Firestore.firestore()
        let playlistRef = db.collection("playlists").document(playlistId)

        // Update the playlist name
        playlistRef.updateData(["name": newName]) { error in
            if let error = error {
                print("Failed to edit playlist name: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Playlist name updated successfully.")
                // Update the local playlist array
                if let index = self.userPlaylists.firstIndex(where: { $0.id == playlistId }) {
                    self.userPlaylists[index].name = newName
                }
                completion(true)
            }
        }
    }
}
