import SwiftUI

struct FavoritesView: View {
    @ObservedObject private var favoritesViewModel = FavoritesViewModel()
    @State private var playlists: [Playlist] = []
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Favorites")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                if isLoading {
                    ProgressView("Loading playlists...")
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if playlists.isEmpty {
                    Text("No playlists available.")
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    PlaylistsListView(playlists: $playlists, onDelete: deletePlaylist)
                }
                
                Spacer()
            }
            .background(Color("MidnightColor").ignoresSafeArea())
            .onAppear {
                fetchPlaylists()
            }
            .navigationTitle("Favorites")
            .navigationBarHidden(true)
            .background(Color("MidnightColor"))
        }
    }
    
    
    private func fetchPlaylists() {
        isLoading = true
        favoritesViewModel.fetchUserPlaylists { fetchedPlaylists in
            self.playlists = fetchedPlaylists ?? []
            self.isLoading = false
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

struct PlaylistsListView: View {
    @Binding var playlists: [Playlist]
    let onDelete: (String) -> Void

    var body: some View {
        List {
            ForEach($playlists) { $playlist in
                NavigationLink(destination: FavoriteDetailView(playlist: $playlist)) {
                    PlaylistRow(
                        playlist: playlist,
                        onDelete: { onDelete(playlist.id ?? "") }
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        onDelete(playlist.id ?? "")
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .listRowBackground(Color("MidnightColor"))
            }
        }
        .listStyle(PlainListStyle())
    }
}

#Preview {
    FavoritesView()
}
