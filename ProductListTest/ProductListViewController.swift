//
//  ProductListViewController.swift
//  ProductListTest
//
//  Created by Andrei Mirzac on 07/09/2019.
//  Copyright © 2019 Andrei Mirzac. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 5.0, bottom: 20.0, right: 5.0)
    let columns: CGFloat = 2
    let spaceBetweenRows: CGFloat = 20
    let spaceBetweenColumns: CGFloat = 0
    let interItemSpacing: CGFloat = 10
    
    lazy var viewModel: ProductListViewModel =  {
        let url = "https://api.net-a-porter.com/NAP/GB/en/60/0/summaries?categoryIds=2"
        let resource = Resource<ProductCategory>(url: url)
        let networkService = NetworkService()
        return ProductListViewModel(networkService: networkService, resource: resource)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        registerCells()
        viewModel.loadProducts()
    }
    
    func bindViewModel() {
        viewModel.updateContent = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func registerCells() {
        let nib = UINib(nibName: ProductViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: ProductViewCell.reuseIdentifier)
    }
}

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: ProductViewCell.reuseIdentifier, for: indexPath) as? ProductViewCell else {
            return UICollectionViewCell()
        }
        let product = viewModel.products[indexPath.row]
        cell.setUp(product: product)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }
}

extension ProductListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let product = viewModel.products[indexPath.row]
        guard let imageUrl = product.images.url() else {
            return
        }
        
        ImageDownloadManager.shared.downloadImage(with: imageUrl, at: indexPath) { (image, url, indexPath, error) in
            DispatchQueue.main.async {
                (cell as? ProductViewCell)?.imageView.image = image
            }
        }
    }
}


extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Width
        let screenWidth = UIScreen.main.bounds.width
        let paddingSpace = sectionInsets.left * (columns)
        let availableWidth = screenWidth - paddingSpace - interItemSpacing
        let width = availableWidth / columns
        
        // Height
        let height = width + (width / 2)
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spaceBetweenColumns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spaceBetweenRows
    }
}
