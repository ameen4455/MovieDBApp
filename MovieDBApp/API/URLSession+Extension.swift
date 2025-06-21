//
//  URLSessionProtocol.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import Foundation

/// A protocol to enable mocking of URLSession for network testing.
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}


extension URLSession: URLSessionProtocol {}
