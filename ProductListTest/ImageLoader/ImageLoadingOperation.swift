//
//  ImageLoadingOperation.swift
//  ProductListTest
//
//  Created by Andrei Mirzac on 08/09/2019.
//  Copyright © 2019 Andrei Mirzac. All rights reserved.
//

import UIKit

class ImageLoadingOperation: AsynchronousOperation {
    
    private var imageUrl: URL
    private var indexPath: IndexPath
    
    var imageDownloadHandler: ImageDownloadHandler?
    
    required init (url: URL, indexPath: IndexPath) {
        self.imageUrl = url
        self.indexPath = indexPath
    }
    
    override func main() {
        super.main()
        guard !isCancelled else {
            state = .finished
            return
        }
        state = .executing
        downloadImage()
    }
    
    private func downloadImage() {
        let newSession = URLSession.shared
        let downloadTask = newSession.downloadTask(with: imageUrl) { (url, response, error) in
            if let url = url, let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                self.imageDownloadHandler?(image, self.imageUrl, self.indexPath, error)
            }
            self.state = .finished
        }
        downloadTask.resume()
    }
}
