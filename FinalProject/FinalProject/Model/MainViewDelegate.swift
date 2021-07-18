//
//  MainViewDelegate.swift
//  FinalProject
//
//  Created by Антон Сафронов on 07.07.2021.
//

import Foundation

//MARK:  протокол для делегирования, когда будем открывать новую картинку. Решить, эни тут или другое
protocol MainViewDelegate: AnyObject {
//    func newDrawing()
//    func picturesCount() -> Int
//    func picture(at index: IndexPath) -> PictureModel
//    func firstCellisHidden()
//    func firstCellisntHidden()
//    func didTap(at index: IndexPath)
//    func didTapNewDrawingButton()
    func selected(at index: IndexPath)
    func settingsTapped()
}

protocol PhotoViewDelegate {
    func photoAddInFavorite(photo: GetPhotosDataResponse) 
}

protocol FavoritePhotosModelDelegate {
    func addFavoritePhotos(photo: GetPhotosDataResponse)
    func putStoredPhotos() -> [GetPhotosDataResponse]
}

protocol ButtonTappedDelegate {
    func buttonIsTaped()
}

//MARK: протокол для установки вью, подумать куда впиихнуть
protocol ViewProtocol: class {
    func setupView()
}
