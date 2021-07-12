//
//  PhotoModel.swift
//  FinalProject
//
//  Created by Антон Сафронов on 08.07.2021.
//

// MARK: Надо убрать отсюда uikit, да?
import UIKit

struct PhotoModel {
    static let photos: [UIImage] = ["cat1", "cat2", "cat3", "cat4", "cat5", "cat6", "cat7", "cat8", "cat9", "cat10", "cat11", "cat12", "cat13", "cat14", ].map { image in
        UIImage(named: "\(image)") ?? UIImage()
    }
    
//    static let photos: [UIImage] = ["cat1", "cat2", "cat3", "cat4", "cat5", "cat6", "cat7", "cat8", "cat9", "cat10", "cat11", "cat12", "cat13", "cat14", ].map { UIImage(named: "\($0)")! }
    
//    static let photo: UIImage = UIImage(named: "cat6") ?? UIImage()
}

