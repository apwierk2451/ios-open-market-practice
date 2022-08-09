//
//  HTTPMethod.swift
//  OpenMarket
//
//  Created by bonf, kiwi on 2022/08/09.
//

enum HTTPMethod {
    case get
    case post
    case delete
    case patch
    case put
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .patch:
            return "PATCH"
        case .put:
            return "PUT"
        }
    }
}
