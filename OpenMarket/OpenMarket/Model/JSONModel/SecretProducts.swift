//
//  SecretProducts.swift
//  OpenMarket
//
//  Created by bonf, kiwi on 2022/08/12.
//

struct SecretProducts: Codable {
    let secret: String
    
    private enum CodingKeys: String, CodingKey {
        case secret
    }
}
