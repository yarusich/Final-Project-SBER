//
//  PhotoNetworkServiceProtocol.swift
//  FinalProject
//
//  Created by Антон Сафронов on 16.07.2021.
//

import Foundation

typealias GetPhotosAPIResponse = Result<GetPhotosResponse, NetworkServiceError>

protocol PhotoNetworkServiceProtocol {
    func getPhotos(after cursor: String?, complition: @escaping (GetPhotosAPIResponse) -> Void)
//    func searchPhotos(after cursor: String?, responseString: String, complition: @escaping (GetPhotosAPIResponse) -> Void)
    func loadPhoto(imageUrl: String, complition: @escaping (Data?) -> Void)
}
