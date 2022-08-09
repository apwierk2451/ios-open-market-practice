//
//  APIRequest.swift
//  OpenMarket
//
//  Created by bonf, kiwi on 2022/08/09.
//

import Foundation

protocol APIRequest {
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var headers: [String: String] { get }
    var query: [String: String] { get }
    var body: Data? { get }
    var path: String { get }
}

extension APIRequest {
    var url: URL? {
        var urlComponents = URLComponents(string: baseURL + path)
        urlComponents?.queryItems = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        return urlComponents?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = self.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpBody = body
        urlRequest.httpMethod = method.name
        headers.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return urlRequest
    }
}
