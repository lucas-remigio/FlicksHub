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
    var onAddToPlaylist: (Playlist) -> Void
    var onCreateNewPlaylist: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Add to Playlist")
                .font(.title2)
                .fontWeight(.bold)

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(playlists) { playlist in
                        Button(action: { onAddToPlaylist(playlist) }) {
                            Text(playlist.name)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.2))
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

                Button(action: onCreateNewPlaylist) {
                    Text("Create Playlist")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            } else {
                Button(action: { isCreatingPlaylist = true }) {
                    Text("Create New Playlist")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                }
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .padding()
        .shadow(radius: 10)
    }
}
