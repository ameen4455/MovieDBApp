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
        
        do {
            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.networkError
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.networkError
            }

            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
            
        } catch is DecodingError {
            throw NetworkError.parsingError
        } catch {
            throw NetworkError.networkError
        }
    }
}

