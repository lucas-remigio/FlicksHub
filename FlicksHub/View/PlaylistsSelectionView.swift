import Foundation
import Combine
import SwiftUI
import SwiftUICore

struct PlaylistSelectionView: View {
    @Binding var playlists: [Playlist]
    @Binding var isCreatingPlaylist: Bool
    @Binding var newPlaylistName: String
    let movieId: Int?
    @State private var errorMessage: String? = nil
    var onAddToPlaylist: (Playlist) -> Void
    var onCreateNewPlaylist: (Bool) -> Void
    
    @ObservedObject var favoritesViewModel = FavoritesViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Add to Playlist")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(playlists) { playlist in
                        Button(action: { onAddToPlaylist(playlist) }) {
                            HStack {
                                Text(playlist.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color("MidnightGrayColor"))
                                    .foregroundColor(.white)
                                
                                // Check if the current movie is in the playlist
                                if playlist.movies.contains(movieId ?? 0) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color("AccentColor"))
                                        .padding(.trailing, 20)  // Adjust padding for alignment
                                }
                            }
                            .background(Color("MidnightGrayColor"))
                            .cornerRadius(8)
                        }
                    }
                }
            }

            Divider().padding(.vertical, 10)

            if isCreatingPlaylist {
                VStack(spacing: 10) {
                    TextField("Playlist Name", text: $newPlaylistName)
                        .padding()
                        .background(Color("MidnightGrayColor"))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .placeholder(when: newPlaylistName.isEmpty) {
                            Text("Enter playlist name")
                                .foregroundColor(Color.white)
                                .padding(.leading, 10)
                        }

                    Button(action: {
                        favoritesViewModel.createPlaylist(name: newPlaylistName) { success, error, playlistId in
                            if success {
                                // Add movie to playlist created
                                favoritesViewModel
                                    .addMovieToPlaylist(
                                        playlistId: playlistId ?? "",
                                        movieId: movieId ?? 0
                                    ) { success in
                                        if success {
                                            isCreatingPlaylist = false  // Exit creation mode
                                            onCreateNewPlaylist(true)   // Close the modal on success
                                        }
                                    }
                            } else {
                                errorMessage = error
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
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    self.errorMessage = nil
                                }
                            }
                    }
                }
                .padding(.horizontal)
            } else {
                Button(action: { isCreatingPlaylist = true }) {
                    Text("Create New Playlist")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("MidnightGrayColor"))
                        .foregroundColor(.white)
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

extension View {
    /// Adds a placeholder to a `TextField`.
    @ViewBuilder func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
