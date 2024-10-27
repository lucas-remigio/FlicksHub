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
                                Button(action: {
                                    selectedPlaylist = playlist
                                    showMovieList = true
                                }) {
                                    HStack {
                                        Text(playlist.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text("\(playlist.movies.count) movies")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color("MidnightGrayColor").opacity(0.9))
                                    .cornerRadius(12)
                                }
                                .padding(.horizontal)
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
                    MovieListView(playlist: playlist)
                }
            }
        }
    }
    
    private func fetchPlaylists() {
        favoritesViewModel.fetchUserPlaylists { fetchedPlaylists in
            self.playlists = fetchedPlaylists ?? []
        }
    }
}

struct MovieListView: View {
    var playlist: Playlist
    
    var body: some View {
        VStack {
            Text(playlist.name)
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.white)
            
            if playlist.movies.isEmpty {
                Text("No movies in this playlist.")
                    .foregroundColor(.gray)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(playlist.movies, id: \.self) { movieId in
                            Text("Movie ID: \(movieId)")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("MidnightGrayColor").opacity(0.9))
                                .cornerRadius(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            Spacer()
        }
        .background(Color("MidnightColor").ignoresSafeArea())
    }
}

#Preview {
    FavoritesView()
}
