//
//  MainViewModel.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 05/10/2024.
//
import Combine
import Foundation

class MainViewModel: ObservableObject {
    @Published var movieList: [Movie]?

        init() {
            // Fetch movies when the view model is initialized
            retrieveMovies()
        }

        func retrieveMovies() {
            APICaller.getTrendingMovies() { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.movieList = response.results
                        print(self.movieList as Any)
                    }
                case .failure(let error):
                    print("Failed to retrieve movies: \(error)")
                }
            }
        }
}
