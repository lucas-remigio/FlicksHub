//
//  MainView.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 05/10/2024.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel = MainViewModel()
    @State var searchText: String = ""
    
    // Define the grid layout with two columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                   ForEach(viewModel.movieList) { movie in
                        if let posterPath = movie.posterPath,
                           let imageUrl = URL(string: "\(NetworkConstant.shared.imageServerAddress)\(posterPath)") {
                            NavigationLink(destination: DetailView(movieId: movie.id)) {
                                AsyncImage(url: imageUrl) { phase in
                                    switch phase {
                                        case .empty:
                                            ProgressView()  // Show loading spinner while image is being fetched
                                                .frame(height: 300)
                                            // Success case
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 300)
                                        case .failure:
                                            // Show an error image or placeholder if the image fails to load
                                            Image(systemName: "xmark.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 300)
                                                .foregroundColor(.red)
                                        @unknown default:
                                            // Fallback for future cases
                                            Image(systemName: "questionmark")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 300)
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding()
            }
            .scrollContentBackground(.hidden)
            .background(Color("MidnightColor"))
            .onAppear {
                viewModel.retrieveMovies()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    MainView()
}
