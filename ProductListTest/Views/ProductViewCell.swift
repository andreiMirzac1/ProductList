//
//  RecipeListViewCell.swift
//
//  Created by Andrei Mirzac on 15/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation
import UIKit

class ProductViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ProductViewCell"
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var price: UILabel!
    
    func setUp(product: Product) {
        imageView.image = UIImage(named: "default_image")
        title.text = product.name
        price.text = product.price.description
    }
}
