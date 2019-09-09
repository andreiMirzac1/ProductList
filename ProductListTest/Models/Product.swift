//
//  Product.swift
//  ProductListTest
//
//  Created by Andrei Mirzac on 07/09/2019.
//  Copyright © 2019 Andrei Mirzac. All rights reserved.
//

import Foundation

struct Product: Codable, Equatable {
    
    let name: String
    let id: Int
    let price: Price
    let images: Images
}

struct Images: Codable, Equatable {
    let urlTemplate: String
    let sizes: [String]
    
    func url() -> URL? {
        guard let size = sizes.first else {
            return nil
        }
        let stringUrl = urlTemplate.replacingOccurrences(of: "{{scheme}}", with: "https:").replacingOccurrences(of: "{{shot}}", with: "in").replacingOccurrences(of: "{{size}}", with: size)
        return URL(string: stringUrl)
    }
}
