//
//  MockSession.swift
//  OpenMarket
//
//  Created by bonf, kiwi on 2022/08/09.
//
import Foundation

final class MockSession: SessionProtocol {
    func dataTask(with request: APIRequest,
                  completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard let mockData = MockData(fileName: "Products").data else {
            completionHandler(.failure(CodableError.decode))
            return
        }
        completionHandler(.success(mockData))
    }
}

