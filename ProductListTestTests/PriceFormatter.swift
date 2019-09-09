//
//  PriceFormatter.swift
//  ProductListTestTests
//
//  Created by Andrei Mirzac on 09/09/2019.
//  Copyright © 2019 Andrei Mirzac. All rights reserved.
//

import XCTest
@testable import ProductListTest

class PriceFormatterTests: XCTestCase {
    
    func testCurrencyformatterReturnsCorrectString() {
        let price = Price(currency: "GBP", divisor: 100, amount: 40000)
        let priceString = PriceFormatter.string(from: price)
        XCTAssert(priceString == "£400.00")
    }
}
