//
//  Resource.swift
//  ProductListTest
//
//  Created by Andrei Mirzac on 14/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation

struct Resource<A> {
    
    let url: String
    let method: HttpMethod
    let parse: (Data) -> A?
    
    init(url: String, parse: @escaping (Data) -> A?, method: HttpMethod = .GET) {
        self.url = url
        self.method = method
        self.parse = parse
    }
}

extension Resource where A: Codable {
    init(url: String, method: HttpMethod = .GET) {
        self.url = url
        self.method = method
        self.parse = { data in
            let decodedObject: A? = try? JSONDecoder().decode(A.self, from: data)
            return decodedObject
        }
    }
}

