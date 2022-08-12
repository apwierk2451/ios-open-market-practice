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
    var query: [String: String]?
    var body: HTTPBody?
    var path: String
}

struct TestRequest: APIRequest {
    var body: HTTPBody?
    var path: String
    var boundary: String?
    var method: HTTPMethod
    var baseURL: String
    var headers: [String: String]?
    var query: [String: String]?
}

class APIRequestTest: XCTestCase {
    var sut: GetData!
    let boundary = "Boundary-\(UUID().uuidString)"
    
    override func setUpWithError() throws {
        sut = GetData(method: .get, baseURL: URLHost.openMarket.url, path: "")
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_GET_메서드_동작확인() {
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
    
    func test_POST_메서드_동작확인() {
        //given
        let expectation = expectation(description: "비동기테스트")
        guard let assetImage = UIImage(named: "귀요미") else { return }
        guard let pngData = assetImage.pngData() else { return }
        let product = RegistrationProduct(name: "열심히하자",
                                          descriptions: "화이팅",
                                          price: 10000.0,
                                          currency: "KRW",
                                          discountedPrice: 0.0,
                                          stock: 1,
                                          secret: UserInfo.secret.text)
        guard let productData = try? JSONEncoder().encode(product) else { return }
        let multiPartFormData = MultiPartForm(boundary: boundary, jsonData: productData, images: [Image(name: "귀요미", data: pngData, type: "png")])
        let networkManager = NetworkManager()
        let request = TestRequest(body: .multiPartForm(multiPartFormData) ,path: URLAdditionalPath.product.value, method: .post, baseURL: URLHost.openMarket.url, headers: ["identifier": UserInfo.identifier.text, "Content-Type": "multipart/form-data; boundary=\(boundary)"])
        networkManager.dataTask(with: request) { result in
            switch result {
            case .success(let success):
                print(String(decoding: success, as: UTF8.self))
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 300)
    }
    
    func test_PATCH_메서드_동작확인() {
        //given
        let expectation = expectation(description: "비동기테스트")
        
        let product = RegistrationProduct(name: "수정수정",
                                          descriptions: "화이팅",
                                          price: 15000.0,
                                          currency: "USD",
                                          discountedPrice: 0.0,
                                          stock: 3,
                                          secret: UserInfo.secret.text)
        guard let productData = try? JSONEncoder().encode(product) else { return }
        let networkManager = NetworkManager()
        let request = TestRequest(body: .json(productData),
                                  path: URLAdditionalPath.product.value + "/4523/",
                                  method: .patch,
                                  baseURL: URLHost.openMarket.url,
                                  headers: ["identifier": UserInfo.identifier.text, "Content-Type": "application/json"])
        networkManager.dataTask(with: request) { result in
            switch result {
            case .success(let success):
                print(String(decoding: success, as: UTF8.self))
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 300)
    }
    
    func test_POST_Secret() {
        //given
        let expectation = expectation(description: "비동기 요청을 기다림.")
        let networkManager = NetworkManager()
        let body = SecretProducts(secret: UserInfo.secret.text)
        guard let data = try? JSONEncoder().encode(body) else { return }
        let deleteRequest = TestRequest(body: .json(data),
                                        path: URLAdditionalPath.product.value + "/4521/secret",
                                        method: .post,
                                        baseURL: URLHost.openMarket.url ,
                                        headers: ["identifier": UserInfo.identifier.text,
                                                  "Content-Type" : "application/json"])
        networkManager.dataTask(with: deleteRequest) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                print(String(decoding: success, as: UTF8.self))
            case .failure(let error):
                print(error)
                break
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 300)
    }
    
    func test_DELETE_메서드_동작확인() {
        // given
        let expectation = expectation(description: "비동기 요청을 기다림.")
        let networkManager = NetworkManager()
        let deleteRequest = TestRequest(path: URLAdditionalPath.product.value + "/4521/c4ac3ef5-1a03-11ed-9676-49deb877d7ab",
                                        method: .delete,
                                        baseURL: URLHost.openMarket.url,
                                        headers: ["identifier": UserInfo.identifier.text,
                                                  "Content-Type" : "application/json"])
        networkManager.dataTask(with: deleteRequest) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                print(String(decoding: success, as: UTF8.self))
            case .failure(let error):
                print(error)
                break
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 300)
    }
}

