//
//  Movie.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 23/06/25.
//

import Foundation

struct Movie: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String?
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case backdropPath = "backdrop_path"
    }
    
    var fullPosterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: APIConstants.tmdbImageBaseURL + posterPath)
    }
    
    var fullBackDropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: APIConstants.tmdbImageBaseURL + backdropPath)
    }
}
