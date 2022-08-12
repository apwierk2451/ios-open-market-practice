//
//  UIImageView + Extension.swift
//  OpenMarket
//
//  Created by bonf, kiwi on 2022/08/09.
//

import UIKit

extension UIImageView {
    func setImageUrl(url: String) {
        guard let safeUrl = URL(string: url) else { return }
        let cachedKey = NSString(string: url)
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: safeUrl) { data, response, error in
            guard error == nil else { return }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else { return }
            
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            ImageCacheManager.shared.setObject(image, forKey: cachedKey)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
