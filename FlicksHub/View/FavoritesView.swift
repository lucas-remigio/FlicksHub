//
//  FavoritesView.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 10/10/2024.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject private var favoritesViewModel = FavoritesViewModel()
    @State private var playlists: [Playlist] = []  // Stores user playlists
    @State private var selectedPlaylist: Playlist?  // Currently selected playlist
    @State private var showMovieList = false  // Toggles movie list view for selected playlist
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Favorites")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.top, 5)
                
                if playlists.isEmpty {
                    Text("No playlists available.")
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(playlists) { playlist in
                                PlaylistRow(
                                    playlist: playlist,
                                    onSelect: {
                                        selectedPlaylist = playlist
                                        showMovieList = true
                                    },
                                    onDelete: {
                                        deletePlaylist(with: playlist.id ?? "")
                                    }
                                )
                            }
                        }
                        .padding(.top)
                    }
                }
                
                Spacer()
            }
            .background(Color("MidnightColor").ignoresSafeArea())
            .onAppear {
                fetchPlaylists()
            }
            .navigationTitle("Favorites")
            .navigationBarHidden(true)
            .sheet(isPresented: $showMovieList) {
                if let playlist = selectedPlaylist {
                    FavoriteDetailView(playlist: playlist)
                }
            }
        }
    }
    
    private func fetchPlaylists() {
        favoritesViewModel.fetchUserPlaylists { fetchedPlaylists in
            self.playlists = fetchedPlaylists ?? []
        }
    }
    
    private func deletePlaylist(with playlistId: String) {
        // Call the delete function on the view model
        favoritesViewModel.deletePlaylist(playlistId: playlistId) { success in
            if success {
                // Find the index of the playlist with the specified ID
                if let index = playlists.firstIndex(where: { $0.id == playlistId }) {
                    playlists.remove(at: index)  // Remove playlist from local list
                }
            } else {
                print("Failed to delete playlist.")
            }
        }
    }
}



#Preview {
    FavoritesView()
}
