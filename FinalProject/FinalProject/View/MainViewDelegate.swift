//
//  MainViewDelegate.swift
//  FinalProject
//
//  Created by Антон Сафронов on 07.07.2021.
//

import Foundation

//MARK:  протокол для делегирования, когда будем открывать новую картинку. Решить, эни тут или другое
protocol MainViewDelegate: AnyObject {

    func selected(at index: IndexPath)
    func settingsTapped()
}

protocol PhotoViewDelegate {
    func photoAddInFavorite(photo: PhotoDTO) 
}

protocol FavoritePhotosModelDelegate {
    func addFavoritePhotos(photo: PhotoDTO)
    func putStoredPhotos() -> [PhotoDTO]
}

protocol ButtonTappedDelegate {
    func buttonIsTaped()
}

//MARK: протокол для установки вью, подумать куда впиихнуть
protocol ViewProtocol: class {
    func setupView()
}
