//
//  ImageScrollView.swift
//  FinalProject
//
//  Created by Антон Сафронов on 27.07.2021.
//

import UIKit

class ImageScrollView: UIScrollView {
    
    var imageZoomView: UIImageView?
    
    func set(image: UIImage) {
        imageZoomView?.removeFromSuperview()
        imageZoomView = nil
        
        imageZoomView = UIImageView(image: image)
        guard let imageZoomView = imageZoomView else { return }
        self.addSubview(imageZoomView)
    }
}
