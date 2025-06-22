//
//  Helpers.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//


import XCTest
@testable import MovieDBApp

class URLSessionMock: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        
        guard let data = data, let response = response else {
            fatalError("Mock data or response not set for URLSessionMock.data(for: URLRequest).")
        }
        return (data, response)
    }
}

// A simple Decodable struct to use as a generic type `T` in tests
struct TestCodable: Codable, Equatable {
    let id: Int
    let name: String
}

struct EmptyDecodable: Codable {
    
}
