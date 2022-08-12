//
//  Data + Extension.swift
//  OpenMarket
//
//  Created by bonf, kiwi on 2022/08/12.
//

import Foundation

extension Data {
    mutating func append(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        
        self.append(data)
    }
}
