//
//  DetailView.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 10/10/2024.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel = MovieDetailViewModel()
    @ObservedObject var favoritesViewModel = FavoritesViewModel()
    @State private var contentLoaded = false
    let movieId: Int
    @State private var isFavorite: Bool = false
    @State private var showPlaylistPopup: Bool = false  // Controls the popup visibility
    @State private var playlists: [Playlist] = []       // Stores user playlists
    @State private var newPlaylistName: String = ""     // For creating a new playlist
    @State private var isCreatingPlaylist: Bool = false // To show/hide new playlist text field

    var body: some View {
        ZStack {
            // Background Image with Fade Effect
            GeometryReader { geometry in
                if let posterURL = viewModel.movie?.posterPath {
                    AsyncImage(url: URL(string: "\(NetworkConstant.shared.imageServerAddress)\(posterURL)")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height / 1.5)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .frame(width: geometry.size.width, height: geometry.size.height / 1.5)
                    }
                    .overlay(
                        // Apply gradient overlay for fade effect
                        LinearGradient(
                            gradient: Gradient(colors: [
                                    Color("MidnightColor").opacity(1),  // Start of the gradient
                                    Color("MidnightColor").opacity(0.5), // Midpoint
                                    Color("MidnightColor").opacity(0)   // End of the gradient
                                ]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .frame(height: geometry.size.height / 3),
                        alignment: .bottom
                    )
                }
            }
            .ignoresSafeArea()  // Make background image extend under safe area
            

            GeometryReader { geometry in
                // Scrollable Content anchored to the bottom
                VStack {
                    Spacer() // Pushes content to the bottom of the screen
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            // Movie Title, Tagline, Genres, and Release Date
                            Text(viewModel.movie?.title ?? "Title")
                                .font(.title)
                                .bold()
                                .padding(.top)
                            
                            Text(viewModel.movie?.tagline ?? "The world is a stage.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            // Genres
                            HStack {
                                ForEach(viewModel.movie?.genres ?? []) { genre in
                                    Text(genre.name)
                                        .font(.caption)
                                        .padding(6)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(8)
                                }
                            }
                            
                            Text("Release: \(viewModel.movie?.releaseDate ?? "Date")")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Divider()
                                .padding(.vertical, 8)
                            
                            // Rating, Popularity, Runtime
                            HStack(spacing: 20) {
                                Text("\(viewModel.movie?.voteAverage ?? 0.0, specifier: "%.1f") / 10")
                                    .font(.headline)
                                    .padding(6)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(8)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "person.fill")
                                    Text("\(viewModel.movie?.voteCount ?? 0)")
                                        .font(.caption)
                                }
                                
                                Text("\(viewModel.movie?.runtime ?? 0) min")
                                    .font(.caption)
                            }
                            
                            // Movie Overview
                            Text(viewModel.movie?.overview ?? "Movie description here.")
                                .font(.body)
                                .padding(.top)
                        }
                        .padding()
                        .background(Color("MidnightColor").opacity(0.4))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    }
                    .frame(height: geometry.size.height / 2)  // Limit ScrollView height to the bottom half
                    .offset(y: contentLoaded ? 0 : geometry.size.height / 2) // Start it from the bottom half
                    .animation(.easeOut, value: contentLoaded)  // Animate based on contentLoaded state
                }
            }
        }
        .background(Color("MidnightColor").edgesIgnoringSafeArea(.all))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showPlaylistPopup = true  // Toggle favorite state
                    // Add logic here to save or remove from favorites
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(isFavorite ? Color("AccentColor") : .white)
                }
            }
        }
        .onAppear {
            viewModel.retrieveMovieDetails(movieId: movieId)
            contentLoaded = true
            favoritesViewModel.fetchUserPlaylists(completion: {fetchedPlaylists in
                let playlists = fetchedPlaylists ?? []
                self.playlists = playlists
            })
        }
        .sheet(isPresented: $showPlaylistPopup) {
            PlaylistSelectionView(
                playlists: $playlists,
                isCreatingPlaylist: $isCreatingPlaylist,
                newPlaylistName: $newPlaylistName,
                movieId: movieId,
                onAddToPlaylist: { playlist in
                    favoritesViewModel.addMovieToPlaylist(
                        playlistId: playlist.id ?? "",
                        movieId: movieId
                    ) { success in
                        if success {
                            showPlaylistPopup = false  // Only dismiss on success
                        } else {
                            // Handle the error internally without dismissing
                        }
                    }
                },
                onCreateNewPlaylist: { success in
                    if success {
                        showPlaylistPopup = false  // Dismiss the popup on success
                        newPlaylistName = ""
                    } else {
                        // Do not dismiss the popup on failure
                        // Handle the error state, e.g., show an error message
                    }
                }
            ).background(Color("MidnightColor"))
        }
    }
}

#Preview   {
    DetailView(viewModel: MovieDetailViewModel(), movieId: 889737)
}
