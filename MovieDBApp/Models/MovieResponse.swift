//
//  MovieResponse.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 23/06/25.
//

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
