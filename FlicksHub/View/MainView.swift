//
//  MainView.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 05/10/2024.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel = MainViewModel()
    @State var searchText: String = ""
    @State var selectedFilter: String = "Popular" // Default filter
    
    
    // Define the grid layout with two columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
            // Search bar
            HStack {
                NavigationLink(
                    destination: SearchView()
                ) {
                    HStack {
                        Text("Search")
                            .foregroundColor(.gray) // Placeholder style text
                            .padding(10)
                            .background(Color.white.opacity(1))
                            .cornerRadius(8)
                        
                        Spacer()
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.accentColor)
                            .padding(.trailing, 10)
                    }
                    .frame(maxWidth: .infinity) // Ensure it spans the width like a TextField
                    .background(Color.white.opacity(1))
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle()) // Remove default NavigationLink styling
            }
            .padding([.horizontal, .top])
            
            HStack{
                // "Trending" text
                Text(selectedFilter)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Filter button with dropdown options
                Menu {
                    Button("Now Playing") { selectedFilter = "Now Playing" }
                    Button("Popular") { selectedFilter = "Popular" }
                    Button("Top Rated") { selectedFilter = "Top Rated" }
                    Button("Upcoming") { selectedFilter = "Upcoming" }
                } label: {
                    Label("Filter by", systemImage: "arrowtriangle.down.fill")
                        .font(.caption)
                        .padding(10)
                        .background(Color("MidnightGrayColor"))
                        .cornerRadius(8)
                        .fontWeight(.bold)
                }
            }.padding([.horizontal])
            
            // Scrollable grid of movies
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.movieList.filter { movie in
                        searchText.isEmpty || (movie.title.localizedCaseInsensitiveContains(searchText))
                    }) { movie in
                        if let posterPath = movie.posterPath,
                           let imageUrl = URL(string: "\(NetworkConstant.shared.imageServerAddress)\(posterPath)") {
                            NavigationLink(destination: DetailView(movieId: movie.id)) {
                                AsyncImage(url: imageUrl) { phase in
                                    switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(height: 300)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(height: 260)
                                        case .failure:
                                            Image(systemName: "xmark.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 300)
                                                .foregroundColor(.red)
                                        @unknown default:
                                            Image(systemName: "questionmark")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 300)
                                        }
                                    }
                                }
                            .buttonStyle(PlainButtonStyle())
                            }
                        }
                        // Detect the last item and load more movies
                        if viewModel.movieList.last != nil {
                            Text("")
                                .onAppear {
                                    viewModel.loadMoreMovies()
                                }
                        }
                    }
                    .padding()
                }
                .scrollContentBackground(.hidden)
            }
            .background(Color("MidnightColor").edgesIgnoringSafeArea(.all))
            .onAppear {
                viewModel.retrieveMovies(filter: selectedFilter)
            }
            .onChange(of: selectedFilter) {
                viewModel.retrieveMovies(filter: selectedFilter)
            }
        }
        .navigationBarHidden(true)
    }
}




#Preview {
    MainView()
}
