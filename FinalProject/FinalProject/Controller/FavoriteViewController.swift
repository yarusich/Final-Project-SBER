//
//  FavoriteViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 17.07.2021.
//

import UIKit

final class FavoriteViewController: UIViewController {
    
    private let photos: [GetPhotosDataResponse] = FavoriteStor.shared.putStoredPhotos()
    
//   collection view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .magenta
    }
}


