//
//  APIRequest.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import Foundation

enum Method: String {
    case get = "GET"
}

struct APIRequest {
    var method: Method
    var urlString: String
    var headers: [String: String] = [:]
    var queryItems: [URLQueryItem]? = nil

    init(
        method: Method = .get,
        urlString: String,
        headers: [String: String] = [:],
        queryItems: [URLQueryItem]? = nil
    ) {
        self.method = method
        self.urlString = urlString
        self.headers = headers
        self.queryItems = queryItems
    }

    func makeURLRequest() -> URLRequest? {
        guard var components = URLComponents(string: urlString) else {
            return nil
        }

        if let queryItems = queryItems {
            components.queryItems = queryItems
        }

        guard let finalURL = components.url else {
            return nil
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
