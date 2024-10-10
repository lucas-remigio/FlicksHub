//
//  DetailView.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 10/10/2024.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel = MovieDetailViewModel()
    let movieId: Int

    var body: some View {
        VStack {
            // Back Button and Poster Image
            ZStack(alignment: .topLeading) {
                if let posterURL = viewModel.movie?.posterPath {
                    AsyncImage(url: URL(string: "\(NetworkConstant.shared.imageServerAddress)\(posterURL)")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 400)
                    } placeholder: {
                        ProgressView()
                            .frame(height: 400)
                    }
                }
            }

            // Movie Title, Tagline, Genres, and Release Date
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.movie?.title ?? "Title")
                    .font(.title)
                    .bold()
                    .padding(.top)

                Text(viewModel.movie?.tagline ?? "The world is a stage.")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                // Genres
                HStack {
                    ForEach(viewModel.movie?.genres ?? []) { genre in
                        Text(genre.name)
                            .font(.caption)
                            .padding(6)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                }

                Text("Release: \(viewModel.movie?.releaseDate ?? "Date")")
                    .font(.caption)
                    .foregroundColor(.gray)

                Divider()
                    .padding(.vertical, 8)

                // Rating, Popularity, Runtime
                HStack(spacing: 20) {
                    Text("\(viewModel.movie?.voteAverage ?? 0.0, specifier: "%.1f") / 10")
                        .font(.headline)
                        .padding(6)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)

                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                        Text("\(viewModel.movie?.popularity ?? 0)")
                            .font(.caption)
                    }

                    Text("\(viewModel.movie?.runtime ?? 0) min")
                        .font(.caption)
                }

                // Movie Overview
                Text(viewModel.movie?.overview ?? "Movie description here.")
                    .font(.body)
                    .padding(.top)
            }
            .padding()
            .background(Color("MidnightColor"))
            .foregroundColor(.white)
            .cornerRadius(15)
            .padding(.horizontal)

            Spacer()

        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.retrieveMovieDetails(movieId: movieId)
        }
    }
}

