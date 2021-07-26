//
//  ConverterPhoto.swift
//  FinalProject
//
//  Created by Антон Сафронов on 26.07.2021.
//

import Foundation

final class ConverterPhoto {
    static func converter(_ photo: Photo) -> PhotoModel {
        let photoModel = PhotoModel(id: photo.id,
                                    width: photo.width,
                                    height: photo.height,
                                    descript: photo.descript,
                                    author: photo.author,
                                    url: photo.url)
        return photoModel
    }
}
