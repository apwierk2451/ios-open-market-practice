//
//  APIRequestTest.swift
//  APIRequestTest
//
//  Created by bonf, kiwi on 2022/08/09.
//

import XCTest
@testable import OpenMarket

struct GetData: APIRequest {
    var method: HTTPMethod
    var baseURL: String
    var headers: [String: String]?
    var query: [String: String]
    var body: Data?
    var path: String
}

class APIRequestTest: XCTestCase {
    var sut: GetData!
    
    override func setUpWithError() throws {
        sut = GetData(method: .get, baseURL: URLHost.openMarket.url, query: [Product.page.text: "1", Product.itemPerPage.text: "1"], path: "")
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testExample() {
        // given
        let expectation = expectation(description: "비동기테스트")
        let session = MockSession()
        var productName: String?
        
        session.dataTask(with: sut) { result in
            switch result {
            case .success(let data):
                let decodedData = try? JSONDecoder().decode(ProductsList.self, from: data)
                
                productName = decodedData?.pages[0].name ?? ""
            case .failure(let error):
                print(error)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
        
        // when
        let result = "Test Product"
        
        // then
        XCTAssertEqual(productName, result)
    }
}
