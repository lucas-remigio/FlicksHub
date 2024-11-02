//
//  PlaylistRow.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 27/10/2024.
//

import SwiftUI

struct PlaylistRow: View {
    let playlist: Playlist
    let onDelete: () -> Void

    var body: some View {
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
    
    PlaylistRow(playlist: samplePlaylist, onDelete: {})
}
