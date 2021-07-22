//
//  GetPhotosResponse.swift
//  FinalProject
//
//  Created by Антон Сафронов on 15.07.2021.
//

import Foundation

struct PhotoModel {
    let id: String
    let width: Int
    let height: Int
    let description: String
    let author: String
    let url: String
}

struct GetPhotosResponse: Decodable {
    let results: [GetPhotosDataResponse]
}

//GetPhotosDataResponse

struct GetPhotosDataResponse: Decodable {
    let id: String
    let width: Int
    let height: Int
    let description: String
    let user: User
    let urls: PhotoURLs
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case description = "alt_description"
        case user
        case urls
    }
}

struct PhotoURLs: Decodable {
//    let full: String
    let regular: String

}

struct User: Decodable {
    let name: String
}

