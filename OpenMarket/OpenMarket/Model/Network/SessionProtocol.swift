//
//  SessionProtocol.swift
//  OpenMarket
//
//  Created by bonf, kiwi on 2022/08/09.
//

import Foundation

protocol SessionProtocol {
    func dataTask(with request: APIRequest,
                                completionHandler: @escaping (Result<Data, Error>) -> Void)
}
