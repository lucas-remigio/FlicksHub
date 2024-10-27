//
//  PlaylistRow.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 27/10/2024.
//

import SwiftUI

struct PlaylistRow: View {
    let playlist: Playlist
    let onSelect: () -> Void
    let onDelete: () -> Void

    var body: some View {
        Button(action: onSelect) {
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
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive, action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .padding(.horizontal)
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
    
    PlaylistRow(playlist: samplePlaylist, onSelect: {}, onDelete: {})
}
