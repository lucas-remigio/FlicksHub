//
//  TheMovieDB.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 05/10/2024.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case canNotParseData
}

public class MovieDBAPI {
    static func getKey() -> String {
        // Retrieve API key from Info.plist
        return Bundle.main.object(forInfoDictionaryKey: "MOVIEDB_API_KEY") as? String ?? ""
    }
}

public class APICaller {
    
    
    static func getTrendingMovies(completionHandler: @escaping (APIResult<TrendingMovieModel, NetworkError>) -> Void) {
        let urlString = NetworkConstant.shared.serverAddress + "trending/all/day"
        
        // Ensure URL is valid
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print(MovieDBAPI.getKey())
        request.setValue("Bearer \(MovieDBAPI.getKey())", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: url) { dataResponse, urlResponse , error in
            if error == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(TrendingMovieModel.self, from: data) {
                completionHandler(.success(resultData))
            }
            else {
                completionHandler(.failure(.canNotParseData))
            }
        }.resume()
    }
}

enum APIResult<Success, Failure> where Failure: Error {
    case success(Success)
    case failure(Failure)
}
