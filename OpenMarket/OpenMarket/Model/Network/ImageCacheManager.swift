//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by bonf, kiwi on 2022/08/12.
//

import UIKit

class ImageCacheManager {
    static let shared: NSCache<NSString, UIImage> = .init()
    
    private init() { }
}
