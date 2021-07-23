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

//final class FavoriteStor {
//    
//    static let shared = FavoriteStor()
//    
//    private var storePhotos = [PhotoModel]()
//    
//    private init() { }
//    
//    func addFavoritePhotos(photo: PhotoModel) {
//        for item in storePhotos {
//            if item.id == photo.id {
//                print("уже есть \(storePhotos.count)")
//                return
//            }
//        }
//        storePhotos.append(photo)
//        print("фотка добавлена \(storePhotos.count)")
//    }
//
//    func putStoredPhotos() -> [PhotoModel] {
//        return storePhotos
//    }
//
//    func deletePhoto(photo: PhotoModel) {
//        for i in storePhotos.indices {
//            if storePhotos[i].id == photo.id {
//                storePhotos.remove(at: i)
//                print("Фото с индексом \(i) удалено")
//            }
//        }
//    }
//}
//
//extension FavoriteStor: NSCopying {
//    func copy(with zone: NSZone? = nil) -> Any {
//        return self
//    }
//}

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

