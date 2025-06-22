//
//  MockMovieManager.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 22/06/25.
//

import Foundation

class MockMovieManager: MovieManager {
    func fetchPopularMovies(page: Int) async throws -> MovieResponse {
        return try loadResponse(from: "MockMovies")

    }

    func searchMovies(query: String, page: Int) async throws -> MovieResponse {
        return try loadResponse(from: "SearchMockMovies")
    }
    
    private func loadResponse(from resourceName: String) throws -> MovieResponse {
        guard let url = Bundle(for: Self.self).url(forResource: resourceName, withExtension: "json") else {
            throw NSError(
                domain: "MockMovieManager",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "\(resourceName).json not found in bundle."]
            )
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(MovieResponse.self, from: data)
    }
}
