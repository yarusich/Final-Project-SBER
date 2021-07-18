//
//  PhotoView.swift
//  FinalProject
//
//  Created by Антон Сафронов on 12.07.2021.
//

import UIKit

class PhotoView: UIImageView {
    
    private let networkService = NetworkService()

     func setupImage(str url: String) {
        networkService.loadPhoto(imageUrl: url) { data in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            
        }
    }
    
    
}



    
    

