//
//  MovieListView.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import Combine

@MainActor
class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentPage = 1
    @Published var totalPages = 1

    private let movieManager: MovieManagerProtocol

    init(movieManager: MovieManagerProtocol = MovieManager()) {
        self.movieManager = movieManager
    }

    func loadMovies(forPage page: Int) async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            let response = try await movieManager.fetchPopularMovies(page: page)
            if page == 1 {
                self.movies = response.results
            } else {
                self.movies.append(contentsOf: response.results)
            }
            self.totalPages = response.totalPages
            self.currentPage = page
        } catch let networkError as NetworkError {
            self.errorMessage = networkError.localizedDescription
            print("Network Error loading movies: \(networkError)")
        } catch {
            self.errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
            print("Unexpected Error loading movies: \(error)")
        }
        isLoading = false
    }

    func loadInitialMovies() {
        Task {
            await loadMovies(forPage: 1)
        }
    }

    func loadMoreMovies() {
        guard !isLoading && currentPage < totalPages else { return }
        Task {
            await loadMovies(forPage: currentPage + 1)
        }
    }
    
    func shouldLoadMore(movie: Movie) {
        if movie.id == movies.last?.id {
            loadMoreMovies()
        }
    }
}
