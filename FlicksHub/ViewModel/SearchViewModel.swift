import Combine
import Foundation

class SearchViewModel: ObservableObject {
    @Published var movieList: [Movie] = []
    @Published var isLoadingMore = false
    @Published var selectedYear: String = ""  // To filter by year
    @Published var selectedGenre: String = ""  // To filter by genre
    @Published var selectedRating: Double?  // To filter by rating (e.g., 7.0 for 7+)
    
    @Published var years: [String] = (1950...2024).map { "\($0)" } + ["All"]

    private var currentPage = 1
    private var totalPages = 1
    
    func retrieveMovies(page: Int = 1, append: Bool = false) {
        var queryParameters: [String: String] = [
            "page": "\(page)"
        ]

        // Add year filter if selected
        if !selectedYear.isEmpty {
            queryParameters["primary_release_year"] = selectedYear
        }

        // Add genre filter if selected
        if !selectedGenre.isEmpty {
            queryParameters["with_genres"] = selectedGenre
        }

        // Add rating filter if selected
        if let rating = selectedRating {
            queryParameters["vote_average.gte"] = "\(rating)"
        }

        APICaller
            .getMovies(endpoint: "", queryParameters: queryParameters) { [weak self] result in
            switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        self.totalPages = movies.totalPages
                        if append {
                            self.movieList.append(contentsOf: movies.results)
                        } else {
                            self.movieList = movies.results
                        }
                        self.currentPage = page
                        self.isLoadingMore = false
                    }
                case .failure(let error):
                    print("Failed to retrieve movies: \(error)")
                    DispatchQueue.main.async {
                        self?.isLoadingMore = false
                    }
                }
        }
    }
    
    func loadMoreMovies() {
        guard !isLoadingMore, currentPage < totalPages else { return }
        isLoadingMore = true
        let nextPage = currentPage + 1
        retrieveMovies(page: nextPage, append: true)
    }
}
