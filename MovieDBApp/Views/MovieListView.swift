//
//  MovieListView.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import SwiftUI

struct MovieListView: View {
    @Environment(\.dependencyContainer) private var container: DependencyContainer
    @StateObject private var viewModel = MovieListViewModel()
    
    init(movieManager: MovieManager = TMDBMovieManager()) {
        _viewModel = StateObject(wrappedValue: MovieListViewModel(movieManager: movieManager))
    }

    var body: some View {
        NavigationView {
            VStack {
                searchBar
                
                ScrollView {
                    if (viewModel.movies.isEmpty && viewModel.isLoading) || viewModel.isSearching {
                        ProgressView("Loading Movies...").padding()
                    } else if let error = viewModel.errorMessage {
                        errorState(error: error)
                    } else if viewModel.movies.isEmpty {
                        emptyState
                    } else {
                        movieGrid
                        
                        if viewModel.isLoading {
                            ProgressView().padding()
                        }
                    }
                }
                .navigationTitle("Popular Movies")
            }
        }
    }
    
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search movies...", text: $viewModel.searchQuery)
                .textFieldStyle(PlainTextFieldStyle())
                .autocapitalization(.none)
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding([.horizontal, .top])
    }
    
        VStack {
            Text(viewModel.searchQuery.isEmpty
                 ? "No movies found."
                 : "No results for \"\(viewModel.searchQuery)\"")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, 40)
    }
    
    private var movieGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(viewModel.movies) { movie in
                NavigationLink(
                    destination: MovieDetailView(
                        movie: movie,
                        favouritesManager: container.favouriteManager)
                ) {
                    MovieRow(movie: movie)
                        .onAppear {
                            viewModel.shouldLoadMore(movie: movie)
                        }
                }
            }
        }
        .padding()
    }
    
    private func errorState(error: String) -> some View {
        VStack {
            Text("Error: \(error)")
                .foregroundColor(.red)
                .padding()
            Button("Retry") {
                viewModel.retryPressed()
            }
        }
    }
}

#Preview {
    MovieListView()
}
