//
//  MockData.swift
//  APIRequestTest
//
//  Created by bonf, kiwi on 2022/08/09.
//
import Foundation

struct MockData {
    let data: Data?

    init(fileName: String) {
        let location = Bundle.main.url(forResource: fileName, withExtension: "json")
        data = try? Data(contentsOf: location!)
    }
}
