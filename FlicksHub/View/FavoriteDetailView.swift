//
//  FavoriteDetailView.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 27/10/2024.
//

import SwiftUI

struct FavoriteDetailView: View {
    var playlist: Playlist
    @ObservedObject private var viewModel = FavoritesViewModel()
    @State private var isLoading = true  // Track loading state
    
    var body: some View {
            VStack {
                Text(playlist.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(.white)
                
                if isLoading {
                    ProgressView("Loading movies...")
                        .foregroundColor(.gray)
                        .padding()
                } else if viewModel.movies.isEmpty {
                    Text("No movies in this playlist.")
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    List {
                        ForEach(viewModel.movies, id: \.id) { movie in
                            NavigationLink(destination: DetailView(movieId: movie.id)) {
                                MovieRowView(movie: movie)
                            }
                            .buttonStyle(PlainButtonStyle())  // Prevents default button styling interference
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color("MidnightColor").edgesIgnoringSafeArea(.all))
                }
                
                Spacer()
            }
            .background(Color("MidnightColor").ignoresSafeArea())
            .onAppear {
                viewModel.fetchMovies(for: playlist.movies) {
                    isLoading = false  // Set loading state to false once movies are loaded
                }
            }
        }
}

#Preview {
    var samplePlaylist: Playlist {
            return Playlist(
                id: "samplePlaylistID",
                userId: "sampleUserID",
                name: "My Favorite Movies",
                movies: [101, 102, 103, 104]
            )
        }
    
    FavoriteDetailView(playlist: samplePlaylist)
}
