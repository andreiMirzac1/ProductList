//
//  ProductListViewModel.swift
//  ProductListTest
//
//  Created by Andrei Mirzac on 07/09/2019.
//  Copyright © 2019 Andrei Mirzac. All rights reserved.
//

import Foundation

class ProductListViewModel {
    
    private let networkService: NetworkService
    private let resource: Resource<ProductCategory>
    
    private(set) var products = [Product]() {
        didSet {
            updateContent?()
        }
    }
    
    var updateContent: (() -> Void)?
    
    init(networkService: NetworkService, resource: Resource<ProductCategory>) {
        self.networkService = networkService
        self.resource = resource
    }
    
    func loadProducts() {
        networkService.load(resource, completion: { result in
            switch result {
            case .success(let category):
                self.products = category.summaries
            case .error:
                self.products = []
            }
        })
    }
}


