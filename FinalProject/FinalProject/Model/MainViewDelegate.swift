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

//MARK: протокол для установки вью, подумать куда впиихнуть
protocol ViewProtocol: class {
    func setupView()
}
