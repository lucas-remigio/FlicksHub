import Combine
import Foundation

class SearchViewModel: ObservableObject {
    @Published var movieList: [Movie] = []
    @Published var genres: [Genre] = []  // Store genres
    @Published var isLoadingMore = false
    @Published var selectedYear: String = ""  // To filter by year
    @Published var selectedGenre: String = ""  // To filter by genre
    @Published var selectedRating: Double?  // To filter by rating (e.g., 7.0 for 7+)
    @Published var searchText: String = ""
    
    @Published var years: [String] = (1950...2024).map { "\($0)" } + ["All"]

    private var currentPage = 1
    private var totalPages = 1
    private var cancellables: Set<AnyCancellable> = []  // To store Combine subscriptions
    
    func retrieveMovies(page: Int = 1, append: Bool = false) {
        let endpoint = searchText.isEmpty ? "/discover/movie" : "/search/movie"
        
        var queryParameters: [String: String] = [
            "page": "\(page)",
            "include_adult": "false",
            "language": "en-US"
        ]
        
        print("retrieve movies : "  + searchText)
        
        // Add search query if applicable
        if !searchText.isEmpty {
            print("text is not empty " + searchText)
            queryParameters["query"] = searchText
        }

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
            .getMovies(endpoint: endpoint, queryParameters: queryParameters) { [weak self] result in
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
    
    func fetchGenres() {
        APICaller.getGenres { [weak self] result in
            switch result {
            case .success(let genreResponse):
                DispatchQueue.main.async {
                    self?.genres = genreResponse.genres
                }
            case .failure(let error):
                print("Failed to fetch genres: \(error)")
            }
        }
    }
}
