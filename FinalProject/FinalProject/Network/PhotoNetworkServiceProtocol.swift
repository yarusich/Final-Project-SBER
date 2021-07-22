//
//  PhotoNetworkServiceProtocol.swift
//  FinalProject
//
//  Created by Антон Сафронов on 16.07.2021.
//

import Foundation

typealias GetPhotosAPIResponse = Result<GetPhotosResponse, NetworkServiceError>

protocol PhotoNetworkServiceProtocol {
    func searchPhotos(currentPage page: String, searching query: String, completion: @escaping (GetPhotosAPIResponse) -> Void) 
//    func getRandomPhotos(current page: String, complition: @escaping (GetPhotosAPIResponse) -> Void)
    func loadPhoto(imageUrl: String, completion: @escaping (Data?) -> Void)
}
