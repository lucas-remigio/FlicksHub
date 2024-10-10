//
//  MainViewModel.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 05/10/2024.
//
import Combine
import Foundation

class MainViewModel: ObservableObject {
    @Published var movieList: [Movie] = []
    @Published var posterImageURLs: [String] = []

    func retrieveMovies() {
        APICaller.getTrendingMovies() { [weak self] result in
            switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        
                        self.movieList = movies.results
                        // Map over the movies to create full image URLs
                        self.posterImageURLs = movies.results.compactMap { movie in
                            if let posterPath = movie.posterPath {
                                return "\(NetworkConstant.shared.imageServerAddress)\(posterPath)"
                            }
                            return nil
                        }
                                               
                        // For testing purposes, print the image URLs
                        print("Poster Image URLs: \(self.posterImageURLs)")
                    }
                case .failure(let error):
                    print("Failed to retrieve movies: \(error)")
                }
        }
    }
}
