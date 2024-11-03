import Combine
import Foundation

class MainViewModel: ObservableObject {
    @Published var movieList: [Movie] = []
    @Published var isLoadingMore = false  // Indicates if more data is being loaded

    private var currentPage = 1  // Keep track of the current page
    private var totalPages = 1  // Track the total number of pages from the API
    private var selectedFilter = "Popular"  // Keep track of the current filter
    
    // Function to retrieve movies for the selected filter and page
    func retrieveMovies(filter: String, page: Int = 1, append: Bool = false) {
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
        
        // Create query parameters dictionary
        let queryParams: [String: String] = ["page": "\(page)"]
        
        APICaller.getMovies(endpoint: endpoint, queryParameters: queryParams) { [weak self] result in
                switch result {
                    case .success(let movies):
                        DispatchQueue.main.async {
                            guard let self = self else { return }
                            
                            self.totalPages = movies.totalPages  // Store total number of pages

                            if append {
                                // Append new movies to the existing list
                                self.movieList.append(contentsOf: movies.results)
                            } else {
                                // Replace the list with the new movies (for the first page)
                                self.movieList = movies.results
                            }

                            self.currentPage = page  // Update the current page
                            self.isLoadingMore = false  // Stop loading indicator
                        }
                    case .failure(let error):
                        print("Failed to retrieve movies: \(error)")
                        DispatchQueue.main.async {
                            self?.isLoadingMore = false  // Stop loading indicator even on failure
                        }
                    }
            }
    }
    
    // Function to load the next page of movies (for infinite scrolling)
    func loadMoreMovies() {
        guard !isLoadingMore, currentPage < totalPages else { return }
        
        isLoadingMore = true
        let nextPage = currentPage + 1
        
        retrieveMovies(filter: selectedFilter, page: nextPage, append: true)
    }
}
