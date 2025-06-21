//
//  NetworkError.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

/// Custom error types for network operations.
enum NetworkError: Error, Equatable {
    case networkError
    case parsingError
    case invalidUrl
}
