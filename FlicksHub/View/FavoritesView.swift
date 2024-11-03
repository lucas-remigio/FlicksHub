import SwiftUI

struct FavoritesView: View {
    @ObservedObject private var favoritesViewModel = FavoritesViewModel()
    @State private var playlists: [Playlist] = []  // Stores user playlists
    
    @State private var isLoading = true  // Track loading state
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Favorites")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.top, 5)
                
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
                    List {
                        ForEach(playlists) { playlist in
                            NavigationLink(destination: FavoriteDetailView(playlist: playlist)) {
                                PlaylistRow(
                                    playlist: playlist,
                                    onDelete: {
                                        deletePlaylist(with: playlist.id ?? "")
                                    }
                                )
                            }.buttonStyle(PlainButtonStyle())
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    deletePlaylist(with: playlist.id ?? "")
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .listRowBackground(Color("MidnightColor").opacity(1))  // Ensure consistent background
                        }
                    }
                    .listStyle(PlainListStyle())
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

#Preview {
    FavoritesView()
}
