//
//  GetPhotosResponse.swift
//  FinalProject
//
//  Created by Антон Сафронов on 15.07.2021.
//

import Foundation

struct GetPhotosResponse: Decodable {
    let results: [PhotoDTO]
}

struct PhotoDTO {
    let id: String
    let width: Int16
    let height: Int16
    let descript: String
    let author: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case descript = "alt_description"
        case user
        case urls
    }
    enum NameCodingKeys: String, CodingKey {
        case author = "name"
    }
    enum URLCodingKeys: String, CodingKey {
        case url = "regular"
    }
    init(with photoMO: Photo) {
        self.id = photoMO.id
        self.width = photoMO.width
        self.height = photoMO.height
        self.descript = photoMO.descript
        self.author = photoMO.author
        self.url = photoMO.url
        
    }
}

struct PhotoURLs: Decodable {
    let regular: String

}

struct User: Decodable {
    let name: String
}

extension PhotoDTO: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        width = try container.decode(Int16.self, forKey: .width)
        height = try container.decode(Int16.self, forKey: .height)
        descript = try container.decode(String.self, forKey: .descript)
        
        let authorContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .user)
        self.author = try authorContainer.decode(String.self, forKey: .author)
        
        let urlsContainer = try container.nestedContainer(keyedBy: URLCodingKeys.self, forKey: .urls)
        self.url = try urlsContainer.decode(String.self, forKey: .url)
    }
}
