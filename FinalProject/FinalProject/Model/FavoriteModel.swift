//
//  FavoriteModel.swift
//  FinalProject
//
//  Created by Антон Сафронов on 18.07.2021.
//

import UIKit


//protocol FavoriteStoring {
//    func addFavoritePhotos(photo: GetPhotosDataResponse)
//    func putStoredPhotos() -> [GetPhotosDataResponse]
////    func deletePhoto(index: Int)
//}

//  MARK: SINGLTON
final class FavoriteStor {
    
    static let shared = FavoriteStor()
    
    private var storePhotos = [GetPhotosDataResponse]()
    
    private init() { }
    
    func addFavoritePhotos(photo: GetPhotosDataResponse) {
        for item in storePhotos {
            if item.id == photo.id {
                return
            }
        }
        storePhotos.append(photo)
    }

    func putStoredPhotos() -> [GetPhotosDataResponse] {
        return storePhotos
    }

    func deletePhoto(photo: GetPhotosDataResponse) {
        for i in storePhotos.indices {
            if storePhotos[i].id == photo.id {
                storePhotos.remove(at: i)
                print("Фото с индексом \(i) удалено")
            }
        }
    }
}

extension FavoriteStor: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

//final class FavoritePhotosModel: FavoritePhotosModelDelegate {
//
//    private var storePhotos = [GetPhotosDataResponse]()
//
//    func addFavoritePhotos(photo: GetPhotosDataResponse) {
//        storePhotos.append(photo)
//    }
//
//    func putStoredPhotos() -> [GetPhotosDataResponse] {
//        return storePhotos
//    }
//
//    func deletePhoto(index: Int) {
//        storePhotos.remove(at: index)
//    }
//
//}

