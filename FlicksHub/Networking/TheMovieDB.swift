//
//  TheMovieDB.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 05/10/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case networkError(Error)  // Wrap generic Error
    case decodingError(Error)  // Wrap decoding Error
}

enum APIResult<Success, Failure> where Failure: Error {
    case success(Success)
    case failure(Failure)
}

public class MovieDBAPI {
    static func getKey() -> String {
        // Retrieve API key from Info.plist
        return Bundle.main.object(forInfoDictionaryKey: "MOVIEDB_API_KEY") as? String ?? ""
    }
}

public class APICaller {
    static let shared = APICaller()
    
    static func getMovies(endpoint: String, page: Int, completion: @escaping (APIResult<PopularMoviesResponse, NetworkError>) -> Void) {
        let urlString = "\(NetworkConstant.shared.serverAddress)\(endpoint)?language=en-US&page=\(page)"
        
        // Ensure URL is valid
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(MovieDBAPI.getKey())", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                // Decode the response data
                let decodedResponse = try JSONDecoder().decode(PopularMoviesResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.networkError(error)))
            }
        }.resume()
    }
    
    
    
    static func getMovieDetailsById(movieId: Int, completion: @escaping (APIResult<MovieDetail, NetworkError>) -> Void) {
        let urlString = NetworkConstant.shared.serverAddress + "movie/\(movieId)?language=en-US"
        
        // Ensure URL is valid
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(MovieDBAPI.getKey())", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                // Decode the response data into a MovieDetail object
                let decodedResponse = try JSONDecoder().decode(MovieDetail.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    
    static func getMoviesByIds(movieIds: [Int], completion: @escaping (APIResult<[MovieDetail], NetworkError>) -> Void) {
        var movies: [MovieDetail] = []
        let dispatchGroup = DispatchGroup()
        
        for movieId in movieIds {
            dispatchGroup.enter()
            
            // Fetch each movie detail by its ID
            getMovieDetailsById(movieId: movieId) { result in
                switch result {
                case .success(let movieDetail):
                    movies.append(movieDetail)
                case .failure(let error):
                    print("Error fetching movie ID \(movieId): \(error)")
                }
                
                dispatchGroup.leave()
            }
        }
        
        // Notify once all requests are completed
        dispatchGroup.notify(queue: .main) {
            if movies.isEmpty {
                completion(.failure(.noData))  // Handle case when no movies are fetched
            } else {
                completion(.success(movies))
            }
        }
    }

}


