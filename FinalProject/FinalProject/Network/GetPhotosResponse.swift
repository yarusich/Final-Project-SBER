//
//  GetPhotosResponse.swift
//  FinalProject
//
//  Created by Антон Сафронов on 15.07.2021.
//

import Foundation

struct GetPhotosResponse: Decodable {
    let total: Int
    let results: [PhotoDTO]
}

struct PhotoDTO {
    var id: String
    var width: Int16
    var height: Int16
    var descript: String
    var author: String
    var url: String

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
        
        descript = ""
        if let temp = try? container.decode(String.self, forKey: .descript) {
        descript = temp
        }
        
        let authorContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .user)
        self.author = try authorContainer.decode(String.self, forKey: .author)

        let urlsContainer = try container.nestedContainer(keyedBy: URLCodingKeys.self, forKey: .urls)
        self.url = try urlsContainer.decode(String.self, forKey: .url)
    }
}
