//
//  SearchView.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 03/11/2024.
//
import SwiftUI

struct SearchView: View {
    @State var searchText: String = ""
    @ObservedObject var viewModel = SearchViewModel()
    
    @State private var selectedYear: String = "All"  // Default to "All" for Year
    @State private var selectedGenre: String = "All" // Default to "All" for Genre
    @State private var selectedRating: Double = 0.0  // Rating as Double for Slider
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Search bar
                HStack {
                    TextField("Search", text: $searchText)
                        .padding(10)
                        .background(Color.white.opacity(1))
                        .foregroundColor(Color.black)
                        .cornerRadius(8)
                        .overlay(
                            HStack {
                                Spacer()
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Color.accentColor)
                                    .padding(.trailing, 10)
                            }
                        )
                }
                .padding([.horizontal, .top])
                
                // Filters for Year, Genre, and Rating
                HStack(spacing: 10) {
                    // Genre Filter
                    Menu {
                        Button("All") {
                            selectedGenre = "All"
                            viewModel.selectedGenre = "All"
                            viewModel.retrieveMovies()  // Update movies
                        }
                        ForEach(viewModel.genres, id: \.id) { genre in
                            Button(genre.name) {
                                selectedGenre = "\(genre.name)"
                                viewModel.selectedGenre = "\(genre.id)"
                                viewModel.retrieveMovies()  // Update movies
                            }
                        }
                    } label: {
                        Label("Genre: \(selectedGenre)", systemImage: "arrowtriangle.down.fill")
                            .font(.caption)
                            .padding(10)
                            .background(Color("MidnightGrayColor"))
                            .cornerRadius(8)
                    }
                }
                
                // List of movies
                List {
                    ForEach(viewModel.movieList.filter { movie in
                        searchText.isEmpty || movie.title.localizedCaseInsensitiveContains(searchText)
                    }) { movie in
                        NavigationLink(destination: DetailView(movieId: movie.id)) {
                            MovieRowView(movie: movie)
                        }
                        .listRowBackground(Color("MidnightColor"))
                        .buttonStyle(PlainButtonStyle())
                    }
                    // Detect the last item and load more movies
                    if !viewModel.movieList.isEmpty {
                        Text("")
                            .onAppear {
                                viewModel.loadMoreMovies()
                            }
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color("MidnightColor").edgesIgnoringSafeArea(.all))
                .scrollContentBackground(.hidden)
                .onAppear {
                    viewModel.retrieveMovies()
                    viewModel.fetchGenres()  // Fetch genres when the view appears
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SearchView()
}
