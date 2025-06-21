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

    init(method: Method = .get, urlString: String) {
        self.method = method
        self.urlString = urlString
    }
    
    func makeURLRequest() -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
