//
//  PlyalistsSelectionView.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 27/10/2024.
//

import Foundation
import Combine
import SwiftUI
import SwiftUICore

struct PlaylistSelectionView: View {
    @Binding var playlists: [Playlist]
    @Binding var isCreatingPlaylist: Bool
    @Binding var newPlaylistName: String
    let movieId: Int?
    @State private var errorMessage: String?
    var onAddToPlaylist: (Playlist) -> Void
    var onCreateNewPlaylist: (Bool) -> Void
    
    @ObservedObject var favoritesViewModel = FavoritesViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Add to Playlist")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.white)

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(playlists) { playlist in
                        Button(action: { onAddToPlaylist(playlist) }) {
                            Text(playlist.name)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("MidnightGrayColor"))
                                .foregroundColor(Color.white)
                                .cornerRadius(8)
                        }
                    }
                }
            }

            Divider().padding(.vertical, 10)

            if isCreatingPlaylist {
                TextField("Playlist Name", text: $newPlaylistName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    favoritesViewModel.createPlaylist(name: newPlaylistName) { success, playlistId in
                        if success {
                            // add movie to playlist created
                            favoritesViewModel
                                .addMovieToPlaylist(
                                    playlistId: playlistId ?? "",
                                    movieId: movieId ?? 0
                                ) { success in
                                       
                                    }
                                                       
                            isCreatingPlaylist = false  // Exit creation mode
                            onCreateNewPlaylist(true)  // Emit event to close modal
                            
                        } else {
                            errorMessage = "A playlist with this name already exists."
                            onCreateNewPlaylist(false)
                        }
                    }
                }) {
                    Text("Create Playlist")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("AccentColor"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                // Show error message if present
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 5)
                }
            } else {
                Button(action: { isCreatingPlaylist = true }) {
                    Text("Create New Playlist")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("MidnightGrayColor"))
                        .cornerRadius(8)
                }
            }

            Spacer()
        }
        .padding()
        .background(Color("MidnightColor"))
        .cornerRadius(20)
        .padding()
        .shadow(radius: 10)
        .onDisappear {
            isCreatingPlaylist = false
        }
    }
}
