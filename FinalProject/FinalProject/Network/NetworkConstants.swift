//
//  NetworkConstants.swift
//  FinalProject
//
//  Created by Антон Сафронов on 14.07.2021.
//

import Foundation

struct NetworkConstants {
    static let accessKey = "k4Nj9HTUUeDQIcOH5wSb8toegXMQ4Gb5tBY2ebUkt5o"
    static let secretKey = "wui2O1TAoCAKrAkMSwxml6fP1Nex8nWs49Oe4SVmJ6Q"
//    MARK: "https://api.unsplash.com/photos/?client_id=YOUR_ACCESS_KEY"
    static let baseURLString = "https://api.unsplash.com/photos/?client_id="
    static let sizeImageURLString = "regular"  //small = 400, regular = 1080
//    MARK: Запрос
    static var query: String?
    
}
