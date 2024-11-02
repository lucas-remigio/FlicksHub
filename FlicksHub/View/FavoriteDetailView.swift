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
                MovieListView()
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

    private func MovieListView() -> some View {
        List {
            ForEach(viewModel.movies, id: \.id) { movie in
                NavigationLink(destination: DetailView(movieId: movie.id)) {
                    MovieRowView(movie: movie)
                }
                .buttonStyle(PlainButtonStyle())  // Prevents default button styling interference
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        deleteMovieFromPlaylist(movieId: movie.id)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .listRowBackground(Color("MidnightColor").opacity(1))  // Ensure consistent background
            }
        }
        .listStyle(PlainListStyle())
        .background(Color("MidnightColor").edgesIgnoringSafeArea(.all))
    }

    private func deleteMovieFromPlaylist(movieId: Int) {
        guard let playlistId = playlist.id else { return }
        
        viewModel.removeMovieFromPlaylist(playlistId: playlistId, movieId: movieId) { success in
            if success {
                print("Movie removed from playlist")
            } else {
                print("Failed to remove movie from playlist")
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
