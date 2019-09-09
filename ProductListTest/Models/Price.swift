//
//  Price.swift
//  ProductListTest
//
//  Created by Andrei Mirzac on 07/09/2019.
//  Copyright © 2019 Andrei Mirzac. All rights reserved.
//

import Foundation

struct Price: Codable, Equatable {
    let currency: String
    let divisor: Decimal
    let amount: Decimal
    
    var description: String? {
        return PriceFormatter.string(from: self)
    }
}
