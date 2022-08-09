//
//  SessionProtocol.swift
//  OpenMarket
//
//  Created by bonf, kiwi on 2022/08/09.
//

import Foundation

protocol SessionProtocol {
    func dataTast<T: Decodable>(request: URLRequest, completionHandler: @escaping (Result<T, Error>) -> Void)
}
