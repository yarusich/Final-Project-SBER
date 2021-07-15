//
//  GetPhotosResponse.swift
//  FinalProject
//
//  Created by Антон Сафронов on 15.07.2021.
//

import Foundation

struct GetPhotosResponse: Decodable {
    let results: [GetPhotosDataResponse]
}

struct GetPhotosDataResponse: Decodable {
    let id: String
//    let created_at: Date
//    let width: Int
//    let height: Int
//    let color: UIColor?
//    let description: String
    let urls: PhotoURLs
}



struct PhotoURLs: Decodable {
    let raw: String
    let full: String
    let regular: String    //самое нужное
    let small: String
    let thumb: String
}

//  MARK: Вложить в структуру, для которой написано
//enum CodingKeys: String, CodingKey {
//    case id
//    case createdAt = "created_at"     //можно сделать декодер из снейк кейса в кэмел кейс
//    case width
//    case height
//    case color
//    case description
//    case urls
//}
