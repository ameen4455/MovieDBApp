//
//  MovieListView.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()

    var body: some View {
        NavigationView {
            VStack {
                
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
                
                ScrollView {
                    LazyVStack {
                        if (viewModel.movies.isEmpty && viewModel.isLoading) || viewModel.isSearching {
                            ProgressView("Loading Movies...")
                                .padding()
                        } else if let error = viewModel.errorMessage {
                            VStack {
                                Text("Error: \(error)")
                                    .foregroundColor(.red)
                                    .padding()
                                Button("Retry") {
                                    if viewModel.searchQuery.isEmpty {
                                        viewModel.loadInitialMovies()
                                    } else {
                                        viewModel.retrySearch()
                                    }
                                }
                            }
                        } else {
                            ForEach(viewModel.movies) { movie in
                                NavigationLink(destination: MovieDetailView(movie: movie)) {
                                    MovieRow(movie: movie)
                                        .onAppear {
                                            viewModel.shouldLoadMore(movie: movie)
                                        }
                                }
                            }
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .padding()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationTitle("Popular Movies")
            }
        }
    }
}

#Preview {
    MovieListView()
}
