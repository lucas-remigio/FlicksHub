//
//  MovieDetailViewModel.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 10/10/2024.
//

import Foundation

class MovieDetailViewModel: ObservableObject {
    @Published var movie: MovieDetail?

    func retrieveMovieDetails(movieId: Int) {
        print("hey")
        APICaller.getMovieDetailsById(movieId: movieId) { [weak self] result in
            switch result {
                case .success(let movieDetails):
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        
                        self.movie = movieDetails
                        
                        print(movieDetails)
                    }
                case .failure(let error):
                    print("Failed to retrieve movie details: \(error.localizedDescription)")
            }
        }
    }
}
