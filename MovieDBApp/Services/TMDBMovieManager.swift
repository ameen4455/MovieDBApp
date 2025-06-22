//
//  MovieManager.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import Foundation

struct APIConstants {
    static let tmdbBaseURL = "https://api.themoviedb.org/3"
    static let tmdbImageBaseURL = "https://image.tmdb.org/t/p/w300"
    
    static let popularMoviesPath = "/movie/popular"
    static let searchMoviesPath = "/search/movie"
    static var tmdbAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String else {
            fatalError("TMDB_API_KEY not found in Info.plist")
        }
        return key
    }
}

protocol MovieManager {
    func fetchPopularMovies(page: Int) async throws -> MovieResponse
    func searchMovies(query: String, page: Int) async throws -> MovieResponse
}

class TMDBMovieManager: MovieManager {
    private let apiManager: APIManagerProtocol

    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }

    func fetchPopularMovies(page: Int) async throws -> MovieResponse {
        let request = makeAuthedRequest(
            path: APIConstants.popularMoviesPath,
            queryItems: [URLQueryItem(name: "page", value: "\(page)")]
        )
        return try await apiManager.request(apiRequest: request)
    }

    func searchMovies(query: String, page: Int) async throws -> MovieResponse {
        let request = makeAuthedRequest(
            path: APIConstants.searchMoviesPath,
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
