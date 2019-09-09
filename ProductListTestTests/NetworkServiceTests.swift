//
//  NetworkService.swift
//  ProductListTestTests
//
//  Created by Andrei Mirzac on 08/09/2019.
//  Copyright © 2019 Andrei Mirzac. All rights reserved.
//

import XCTest
@testable import ProductListTest

class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkService!
    let urlString = "http://example.com"
    
    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        networkService = NetworkService(session: session)
    }
    
    func testNetworkServiceReturnsInvalidStatusCodeError() {
        //Given
        let resource = Resource<[Product]>(url: urlString)
        let invalidResponse = NetworkServiceTests.getResponse(statusCode: 400, url: urlString)
        MockURLProtocol.requestHandler = { request in
            return (invalidResponse, Data())
        }
        
        //Then
        let expectation = XCTestExpectation(description: "NetworkService")
        networkService.load(resource) { result in
            switch result {
            case .error(let errorType):
                XCTAssert(errorType == .invalidStatusCode)
            case .success:
                XCTFail("Expected .invalidStatusCode error type")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testNetworkServiceReturnsFailedToParseErrorWhenDataIsInvalid() {
        //Given
        MockURLProtocol.requestHandler = { request in
            let response = NetworkServiceTests.getResponse(statusCode: 200, url: self.urlString)
            return (response, Data())
        }
        
        //Then
        let expectation = XCTestExpectation(description: "NetworkService")
        let resource = Resource<[Product]>(url: urlString)
        networkService.load(resource) { result in
            switch result {
            case .error(let errorType):
                XCTAssert(errorType == .failedToParse)
            case .success:
                XCTFail("Expected .failedToParse error type")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testNetworkServiceLoadProductsSuccesfully() {
        //Given
        MockURLProtocol.requestHandler = { request in
            let data = NetworkServiceTests.loadData(fileName: "products")
            let response = NetworkServiceTests.getResponse(statusCode: 200, url: self.urlString)
            return (response, data)
        }
        
        //Then
        let price = Price(currency: "GBP", divisor: 100, amount: 40000)
        let sizes = ["dl", "l", "m", "m2", "mt", "mt2", "pp", "s", "sl", "xl", "xs", "xxl"]
        let images = Images(urlTemplate: "{{scheme}}//cache.net-a-porter.com/images/products/1161795/1161795_{{shot}}_{{size}}.jpg", sizes: sizes)
        let product = Product(name: "Rives oversized knitted cardigan ",
                                   id: 1161795,
                                   price: price,
                                   images: images)
        
        let expectation = XCTestExpectation(description: "NetworkService")
        let resource = Resource<[Product]>(url: urlString)
        networkService.load(resource) { result in
            switch result {
            case .error:
                XCTFail("Expected a success result")
            case .success(let products):
                XCTAssert(products.count == 1)
                XCTAssert(products[0] == product)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}

extension NetworkServiceTests {
    static func getResponse(statusCode: Int, url: String) -> HTTPURLResponse {
        return HTTPURLResponse(url: URL(string: url)!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    
    static func loadData(fileName: String) -> Data? {
        
        let bundle = Bundle(for: NetworkServiceTests.self)
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {
            return nil
        }
        return FileManager.default.contents(atPath: path)
    }
}
