//
//  NetworkServiceError.swift
//  FinalProject
//
//  Created by Антон Сафронов on 15.07.2021.
//

import Foundation

enum NetworkServiceError: Error {
    case buildingURL
    case network
    case decodable
    case unknown
}
