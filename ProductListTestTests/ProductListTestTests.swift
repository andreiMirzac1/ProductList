//
//  ProductListTestTests.swift
//  ProductListTestTests
//
//  Created by Andrei Mirzac on 07/09/2019.
//  Copyright © 2019 Andrei Mirzac. All rights reserved.
//

import XCTest
@testable import ProductListTest

class ProductListTestTests: XCTestCase {
    
    var viewModel: ProductListViewModel!
    
    override func setUp() {

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let networkService = NetworkService(session: session)
        
        let resource = Resource<ProductCategory>(url: "https://example.com")
        viewModel = ProductListViewModel(networkService: networkService, resource: resource)
    }
    
    func testFailingToLoadProductsUpdateContent() {
        let expectation = XCTestExpectation(description: "NetworkService")
        viewModel.updateContent = { [weak viewModel] in
            XCTAssert(viewModel?.products.isEmpty == true)
            expectation.fulfill()
        }
        
        viewModel.loadProducts()
        wait(for: [expectation], timeout: 1)
    }
    
    func testLoadingProductsUpdatesContent() {
        
        MockURLProtocol.requestHandler = { request in
            let data = NetworkServiceTests.loadData(fileName: "category")
            let response = NetworkServiceTests.getResponse(statusCode: 200, url: "https://example.com")
            return (response, data)
        }
        
        let expectation = XCTestExpectation(description: "NetworkService")
        viewModel.updateContent = { [weak viewModel] in
            expectation.fulfill()
            XCTAssert(viewModel?.products.count == 60)
        }
        
        viewModel.loadProducts()
        wait(for: [expectation], timeout: 1)
    }
}
