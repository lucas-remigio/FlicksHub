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
    
    func retrieveMovies(filter: String) {
        let endpoint: String
        switch filter {
            case "Now Playing":
                endpoint = "/movie/now_playing"
            case "Popular":
                endpoint = "/movie/popular"
            case "Top Rated":
                endpoint = "/movie/top_rated"
            case "Upcoming":
                endpoint = "/movie/upcoming"
            default:
                endpoint = "/movie/popular"  // Default to popular if filter is unknown
        }
    
        APICaller.getMovies(endpoint: endpoint, page: 1) { [weak self] result in
            switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        
                        self.movieList = movies.results
                                               
                        // For testing purposes, print the image URLs
                        print("Movies: \(movies.results)")
                    }
                case .failure(let error):
                    print("Failed to retrieve movies: \(error)")
                }
        }
    }
}
