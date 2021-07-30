//
//  ImageCacheService.swift
//  FinalProject
//
//  Created by Антон Сафронов on 30.07.2021.
//

import UIKit

protocol ImageCacheServiceProtocol  {
    func getImage(key: String) -> UIImage?
    func setImage(image: UIImage, key: String)
}

final class ImageCacheService {
    static let shared = ImageCacheService()
    let imageCache = NSCache<NSString, UIImage>()

    private init() { }
}

extension ImageCacheService: ImageCacheServiceProtocol {
    func getImage(key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }

    func setImage(image: UIImage, key: String) {
        return imageCache.setObject(image, forKey: key as NSString)
    }
}


