//
//  FavoriteDetailView.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 27/10/2024.
//

import SwiftUI


struct FavoriteDetailView: View {
    var playlist: Playlist
    
    var body: some View {
        VStack {
            Text(playlist.name)
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.white)
            
            if playlist.movies.isEmpty {
                Text("No movies in this playlist.")
                    .foregroundColor(.gray)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                List {
                    ForEach(playlist.movies, id: \.self) { movieId in
                        HStack {
                            Text("Movie ID: \(movieId)")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("MidnightGrayColor").opacity(0.9))
                                .cornerRadius(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        .padding(.horizontal)
                        .background(Color("MidnightGrayColor").opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .listStyle(PlainListStyle())  // Adjust styling for a cleaner look
                .background(Color("MidnightColor"))
            }
            Spacer()
        }
        .background(Color("MidnightColor").ignoresSafeArea())
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
