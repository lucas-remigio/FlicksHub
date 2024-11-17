//
//  SearchView.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 03/11/2024.
//
import SwiftUI
import Combine

struct SearchView: View {
    @ObservedObject var viewModel = SearchViewModel()
    
    @State private var selectedYear: String = "All"  // Default to "All" for Year
    @State private var selectedGenre: String = "All" // Default to "All" for Genre
    @State private var selectedRating: Double = 0.0  // Rating as Double for Slider
    
    // A cancellable reference for Combine publishers
    private var cancellables = Set<AnyCancellable>()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Search bar
                HStack {
                    TextField("Search", text: $viewModel.searchText)
                        .padding(10)
                        .background(Color.white.opacity(1))
                        .foregroundColor(Color.black)
                        .cornerRadius(8)
                        .overlay(
                            HStack {
                                Spacer()
                                Button(action: {
                                    viewModel.retrieveMovies()
                                }) {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(viewModel.searchText.isEmpty ? .gray : Color.accentColor)
                                        .padding(.trailing, 10)
                                }
                                .disabled(viewModel.searchText.isEmpty)
                            }
                        )
                }
                .padding([.horizontal, .top])
                
                // Filters for Year, Genre, and Rating
                HStack(spacing: 10) {
                    // Year Filter
                    Menu {
                        ForEach(viewModel.years, id: \.self) { year in
                            Button(year) {
                                selectedYear = year
                                viewModel.selectedYear = year == "All" ? "" : year
                                viewModel.retrieveMovies()
                            }
                        }
                    } label: {
                        Label("Year: \(selectedYear)", systemImage: "arrowtriangle.down.fill")
                            .font(.caption)
                            .padding(10)
                            .background(Color("MidnightGrayColor"))
                            .cornerRadius(8)
                    }
                    
                    Spacer() // Add spacer for even spacing
                    
                    // Genre Filter
                    Menu {
                        Button("All") {
                            selectedGenre = "All"
                            viewModel.selectedGenre = ""
                            viewModel.retrieveMovies()
                        }
                        ForEach(viewModel.genres, id: \.id) { genre in
                            Button(genre.name) {
                                selectedGenre = genre.name
                                viewModel.selectedGenre = "\(genre.id)"
                                viewModel.retrieveMovies()
                            }
                        }
                    } label: {
                        Label("Genre: \(selectedGenre)", systemImage: "arrowtriangle.down.fill")
                            .font(.caption)
                            .padding(10)
                            .background(Color("MidnightGrayColor"))
                            .cornerRadius(8)
                    }
                    
                    Spacer() // Add spacer for even spacing
                    
                    // Rating Filter
                    Menu {
                        VStack {
                            Text("Rating: \(Int(selectedRating))")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                            Slider(value: $selectedRating, in: 0...10, step: 1)
                                .padding(.horizontal)
                                .onChange(of: selectedRating) { _, newValue in
                                    viewModel.selectedRating = newValue == 0 ? nil : newValue
                                    viewModel.retrieveMovies()
                                }
                        }
                        .padding()
                    } label: {
                        Label("Rating: \(Int(selectedRating))", systemImage: "arrowtriangle.down.fill")
                            .font(.caption)
                            .padding(10)
                            .background(Color("MidnightGrayColor"))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                // List of movies
                List {
                    ForEach(viewModel.movieList) { movie in
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
