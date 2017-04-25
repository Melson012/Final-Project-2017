//
//  Extensions.swift
//  p2pchat
//
//  Created by Melson Fernandes on 29/03/2017.
//  Copyright © 2017 codeking. All rights reserved.
//

import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()




extension UIImageView {
    
    func loadImagesUsingCacheUrl(urlString: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        
            let url = URL(string: urlString)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                
                DispatchQueue.main.async {
                    
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                        self.image = downloadedImage
                        
                    }
                    
                }
                
                
            }).resume()
    }
    
}
