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
        ScrollView {
            if viewModel.posterImageURLs?.isEmpty ?? true {
                Text("Loading images...")
                    .foregroundColor(.white)
            } else {
                // Use LazyVGrid to display the images in a grid
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.posterImageURLs!, id: \.self) { imageUrl in
                        AsyncImage(url: URL(string: imageUrl)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()  // Show loading spinner while image is being fetched
                                    .frame(height: 300)
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
                }
            }
        }
        .background(Color("MidnightColor"))  // Add a blue background color to the entire scroll view
        .onAppear {
            viewModel.retrieveMovies()  // Fetch movies when the view appears
        }
    }
}

#Preview {
    MainView()
}
