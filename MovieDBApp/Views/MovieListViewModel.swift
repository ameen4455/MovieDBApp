//
//  MovieListView.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import Foundation
import Combine

@MainActor
class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var isSearching = false
    @Published var errorMessage: String?
    @Published var currentPage = 1
    @Published var totalPages = 1
    @Published var searchQuery = ""

    private let movieManager: MovieManager
    private var cancellables = Set<AnyCancellable>()

    init(movieManager: MovieManager = TMDBMovieManager()) {
        self.movieManager = movieManager
        setupSearch()
    }
    
    private func setupSearch() {
        $searchQuery
            .handleEvents(receiveOutput: { [weak self] query in
                guard let self = self else { return }
                
                if query == searchQuery {
                    return
                }
                
                if !query.isEmpty {
                    self.isSearching = true
                    self.errorMessage = nil
                } else {
                    self.isSearching = false
                }
            })
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                Task {
                    if query.isEmpty {
                        await self.loadMovies(forPage: 1)
                    } else {
                        await self.searchMovies(query: query)
                    }
                }
            }
            .store(in: &cancellables)
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
    
    func searchMovies(query: String) async {
        errorMessage = nil

        do {
            let response = try await movieManager.searchMovies(query: query, page: 1)
            self.movies = response.results
            self.currentPage = 1
            self.totalPages = response.totalPages
        } catch {
            self.errorMessage = "Search failed: \(error.localizedDescription)"
        }

        isSearching = false
    }
    
    func shouldLoadMore(movie: Movie) {
        if movie.id == movies.last?.id {
            loadMoreMovies()
        }
    }
    
    func loadMoreMovies() {
        guard !isLoading && currentPage < totalPages else { return }
        Task {
            await loadMovies(forPage: currentPage + 1)
        }
    }
    
    func retryPressed() {
        Task {
            if searchQuery.isEmpty {
                await loadMovies(forPage: 1)
            } else {
                await searchMovies(query: searchQuery)
            }
        }
    }
}
