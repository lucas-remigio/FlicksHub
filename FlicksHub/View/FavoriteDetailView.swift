import SwiftUI

struct FavoriteDetailView: View {
    @Binding var playlist: Playlist
    // State object persists state between re-renders, so we dont lose the movies when update the name
    @StateObject private var viewModel = FavoritesViewModel()
    @State private var isLoading = true  // Track loading state
    @State private var showEditAlert = false  // Controls the alert for editing the name
    @State private var newPlaylistName = ""  // Stores the new name for the playlist
    @State private var moviesLoaded = false  // To prevent multiple loads
    @State private var message: String? = nil  // Holds error or success message

    var body: some View {
        VStack {
            HStack {
                Text(playlist.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)  // Ensure name stays on one line

                Button(action: {
                    newPlaylistName = playlist.name
                    showEditAlert = true
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.white)
                        .padding(.leading, 8)
                }
            }
            .padding(.horizontal)
            
            // Display error message
            if let message = message {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.message = nil  // Clear message after 3 seconds
                        }
                    }
            }
            
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
            if !moviesLoaded {
                viewModel.fetchMovies(for: playlist.movies) {
                    isLoading = false  // Set loading state to false once movies are loaded
                    moviesLoaded = true  // Mark movies as loaded to prevent re-fetching
                }
            }
        }
        .alert("Edit Playlist Name", isPresented: $showEditAlert) {
            TextField("New Playlist Name", text: $newPlaylistName)
            Button("Save", action: updatePlaylistName)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Enter a new name for the playlist.")
        }
    }

    private func MovieListView() -> some View {
        List {
            ForEach(viewModel.movies, id: \.id) { movie in
                NavigationLink(destination: DetailView(movieId: movie.id)) {
                    MovieRowView(movie: movie)
                }
                .buttonStyle(PlainButtonStyle())  // Prevents default button styling interference
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
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
    
    private func updatePlaylistName() {
        guard let playlistId = playlist.id else { return }

        Task {
            let (success, errorMessage) = await viewModel.editPlaylistName(playlistId: playlistId, newName: newPlaylistName)

            if success {
                playlist.name = newPlaylistName
                print("Playlist name updated")
            } else {
                message = errorMessage ?? "Failed to update playlist name"
                print(message)
            }
        }
    }
}

#Preview {
    @Previewable @State var samplePlaylist = Playlist(
        id: "samplePlaylistID",
        userId: "sampleUserID",
        name: "My Favorite Movies",
        movies: [101, 102, 103, 104]
    )
    
    return FavoriteDetailView(playlist: $samplePlaylist)
}
