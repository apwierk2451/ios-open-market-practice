//
//  UserInfo.swift
//  OpenMarket
//
//  Created by bonf, kiwi on 2022/08/12.
//

enum UserInfo {
    case identifier
    case secret
    
    var text: String {
        switch self {
        case .identifier:
            return "db9ad21f-0335-11ed-9676-d981f203510d"
        case .secret:
            return "MDiJmFcA7K"
        }
    }
}
