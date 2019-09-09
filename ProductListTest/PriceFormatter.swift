//
//  PriceFormatter.swift
//  ProductListTest
//
//  Created by Andrei Mirzac on 09/09/2019.
//  Copyright © 2019 Andrei Mirzac. All rights reserved.
//

import Foundation

struct PriceFormatter {
    
    static func string(from price: Price) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = price.currency
        let result = (price.amount / price.divisor)
        return formatter.string(from: result as NSNumber)
    }
}

