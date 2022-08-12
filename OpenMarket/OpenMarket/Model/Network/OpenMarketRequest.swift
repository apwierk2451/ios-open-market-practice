//
//  OpenMarketRequest.swift
//  OpenMarket
//
//  Created by bonf, kiwi on 2022/08/10.
//

import Foundation

struct OpenMarketRequest: APIRequest {
    var method: HTTPMethod
    var baseURL: String
    var headers: [String : String]?
    var query: [String : String]
    var body: HTTPBody?
    var path: String
}
