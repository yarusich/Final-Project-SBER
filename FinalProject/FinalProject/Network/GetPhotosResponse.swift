//
//  GetPhotosResponse.swift
//  FinalProject
//
//  Created by Антон Сафронов on 15.07.2021.
//

import Foundation

//struct PhotoModel {
//    let id: String
//    let width: Int
//    let height: Int
//
//    let description: String
//
//    let author: String
//
//    let url: String
//
//}

struct GetPhotosResponse: Decodable {
    let results: [PhotoModel]
}

struct PhotoModel {
    let id: String
    let width: Int
    let height: Int
    let description: String
    let author: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case description = "alt_description"
        case user
        case urls
    }
    enum NameCodingKeys: String, CodingKey {
        case author = "name"
    }
    enum URLCodingKeys: String, CodingKey {
        case url = "regular"
    }
}

struct PhotoURLs: Decodable {
//    let full: String
    let regular: String

}

struct User: Decodable {
    let name: String
}

extension PhotoModel: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        description = try container.decode(String.self, forKey: .description)
        
        let authorContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .user)
        self.author = try authorContainer.decode(String.self, forKey: .author)
        
        let urlsContainer = try container.nestedContainer(keyedBy: URLCodingKeys.self, forKey: .urls)
        self.url = try urlsContainer.decode(String.self, forKey: .url)
    }
}
