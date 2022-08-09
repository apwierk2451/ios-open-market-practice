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
    var headers: [String: String]? { get }
    var query: [String: String]? { get }
    var body: Data? { get }
    var path: String? { get }
}
