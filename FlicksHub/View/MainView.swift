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
            if ((viewModel.posterImageURLs?.isEmpty) == nil) {
                Text("Loading images...")
            } else {
                // Use LazyVGrid to display the images in a grid
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.posterImageURLs!, id: \.self) { imageUrl in
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()  // Show loading spinner until the image is loaded
                        }
                        .padding()
                    }
                }
                .padding()  // Add padding around the grid
            }
        }
        .onAppear {
            viewModel.retrieveMovies()  // Fetch movies when the view appears
        }
    }
}

#Preview {
    MainView()
}
