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
            ScrollView {
                LazyVStack {
                    if viewModel.movies.isEmpty && viewModel.isLoading {
                        ProgressView("Loading Movies...")
                            .padding()
                    } else if let error = viewModel.errorMessage {
                        VStack {
                            Text("Error: \(error)")
                                .foregroundColor(.red)
                                .padding()
                            Button("Retry") {
                                viewModel.loadInitialMovies()
                            }
                        }
                    } else {
                        ForEach(viewModel.movies) { movie in
                            MovieRow(movie: movie)
                                .onAppear {
                                    viewModel.shouldLoadMore(movie: movie)
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
            .onAppear {
                if viewModel.movies.isEmpty {
                    viewModel.loadInitialMovies()
                }
            }
        }
    }
}

// MARK: - MovieRow (Individual Movie Item View)

struct MovieRow: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 12) {

                
                RemoteImageView(url: movie.fullPosterURL)
                    .frame(width: 120, height: 180)
                    .cornerRadius(8)

                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.headline)
                        .lineLimit(2)
                    Text(movie.releaseDate ?? "N/A")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Rating: \(movie.voteAverage, specifier: "%.1f")/10")
                        .font(.caption)
                        .foregroundColor(.orange)
                    Text(movie.overview)
                        .font(.body)
                        .lineLimit(3)
                        .padding(.top, 4)
                }
            }
            .padding(.vertical)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Preview Provider (for Xcode Canvas)

#Preview {
    MovieListView()
}
