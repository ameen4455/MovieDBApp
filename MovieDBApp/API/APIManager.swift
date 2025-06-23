//
//  APIManager.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import Foundation

protocol APIManagerProtocol {
    func request<T: Decodable>(apiRequest: APIRequest) async throws -> T
}

class APIManager: APIManagerProtocol {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Decodable>(apiRequest: APIRequest) async throws -> T {
        guard let urlRequest = apiRequest.makeURLRequest() else {
            throw NetworkError.invalidUrl
        }

        let decoder = JSONDecoder()
        let maxRetries = 10 // retry for SSL errors

        for attempt in 1...maxRetries {
            do {
                let (data, response) = try await session.data(for: urlRequest)

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.networkError
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.networkError
                }

                return try decoder.decode(T.self, from: data)
            } catch is DecodingError {
                throw NetworkError.parsingError
            } catch {
                if attempt == maxRetries {
                    throw NetworkError.networkError
                }
                
                // half second delay before SSL retry
                try await Task.sleep(nanoseconds: 500_000_000)
            }
        }

        throw NetworkError.networkError
    }
}

