//
//  ImageDownloadManager.swift
//  ProductListTest
//
//  Created by Andrei Mirzac on 08/09/2019.
//  Copyright © 2019 Andrei Mirzac. All rights reserved.
//

import Foundation
import UIKit

typealias ImageDownloadHandler = (_ image: UIImage?, _ url: URL, _ indexPath: IndexPath, _ error: Error?) -> Void

final class ImageDownloadManager {
    
    lazy var imageDownloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "imageloading.queue"
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    let imageCache = NSCache<NSString, UIImage>()
    static let shared = ImageDownloadManager()
    private init () {}
    
    func cancelAll() {
        imageDownloadQueue.cancelAllOperations()
    }
}

extension ImageDownloadManager {
    
    func downloadImage(with url: URL, at indexPath: IndexPath, handler: @escaping ImageDownloadHandler) {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            // Load from cache
            handler(cachedImage, url, indexPath, nil)
        } else {
            let newOperation = createOperation(with: url, at: indexPath, handler: handler)
            imageDownloadQueue.addOperation(newOperation)
        }
    }
    
    func createOperation(with url: URL, at indexPath: IndexPath, handler: @escaping ImageDownloadHandler) -> ImageLoadingOperation {
        let operation = ImageLoadingOperation(url: url, indexPath: indexPath)
        operation.imageDownloadHandler = { (image, url, indexPath, error) in
            if let newImage = image {
                self.imageCache.setObject(newImage, forKey: url.absoluteString as NSString)
            }
            handler(image, url, indexPath, error)
        }
        return operation
    }
}




