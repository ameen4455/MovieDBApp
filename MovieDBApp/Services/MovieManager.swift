//
//  MovieManager.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import Foundation

struct APIConstants {
    static let tmdbBaseURL = "https://api.themoviedb.org/3"
    static let tmdbAPIKey = ""
    static let tmdbImageBaseURL = "https://image.tmdb.org/t/p/w500"
}

struct MovieResponse: Codable, Equatable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String?
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double

    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    var fullPosterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: APIConstants.tmdbImageBaseURL + posterPath)
    }
    
    static let example = Movie(
        id: 550,
        title: "Fight Club",
        overview: "A depressed man suffering from insomnia and alienation from society.",
        releaseDate: "1999-10-15",
        posterPath: "/pB8BM7pdXLWCbZr8dRvQypB7zTf.jpg",
        voteAverage: 8.4,
        voteCount: 25000,
        popularity: 123.45
    )
}

protocol MovieManagerProtocol {
    func fetchPopularMovies(page: Int) async throws -> MovieResponse
    func fetchMovieDetails(id: Int) async throws -> Movie
    func searchMovies(query: String, page: Int) async throws -> MovieResponse
}

class MovieManager: MovieManagerProtocol {
    private let apiManager: APIManagerProtocol

    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }

    func fetchPopularMovies(page: Int) async throws -> MovieResponse {
        let request = makeAuthedRequest(
            path: "/movie/popular",
            queryItems: [URLQueryItem(name: "page", value: "\(page)")]
        )
        return try await apiManager.request(apiRequest: request)
    }

    func fetchMovieDetails(id: Int) async throws -> Movie {
        let request = makeAuthedRequest(path: "/movie/\(id)")
        return try await apiManager.request(apiRequest: request)
    }

    func searchMovies(query: String, page: Int) async throws -> MovieResponse {
        let request = makeAuthedRequest(
            path: "/search/movie",
            queryItems: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        )
        return try await apiManager.request(apiRequest: request)
    }

    private func makeAuthedRequest(path: String, queryItems: [URLQueryItem]? = nil) -> APIRequest {
        APIRequest(
            urlString: "\(APIConstants.tmdbBaseURL)\(path)",
            headers: [
                "Authorization": "Bearer \(APIConstants.tmdbAPIKey)",
                "accept": "application/json"
            ],
            queryItems: queryItems
        )
    }
}
