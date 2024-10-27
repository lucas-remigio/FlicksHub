//
//  MovieDetailViewModel.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 10/10/2024.
//

import FirebaseFirestore
import FirebaseAuth

class FavoritesViewModel: ObservableObject {
    func createPlaylist(name: String, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in.")
            completion(false)
            return
        }
        
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
                completion(false)
            } else {
                print("Playlist created successfully with ID \(playlistRef.documentID)")
                completion(true)
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
}
