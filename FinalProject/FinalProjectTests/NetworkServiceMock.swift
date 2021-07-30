////
////  NetworkServiceMock.swift
////  FinalProjectTests
////
////  Created by Антон Сафронов on 30.07.2021.
////
//
//import UIKit
//
//class NetworkServiceMock: PhotoNetworkServiceProtocol {
//    
//    let getPhotosResponse: GetPhotosResponse
//    let resultImage: UIImage
//    let networkCompletion: Completion
//    
//    enum Completion {
//        case success
//        case failure
//    }
//
//    init(getPhotosResponse: GetPhotosResponse, resultImage: UIImage, networkCompletion: Completion) {
//        self.getPhotosResponse = getPhotosResponse
//        self.resultImage = resultImage
//        self.networkCompletion = networkCompletion
//    }
//
//    func searchPhotos(currentPage page: String, searching query: String, completion: @escaping (Result<GetPhotosResponse, NetworkServiceError>) -> Void) {
//        switch networkCompletion {
//        case .success:
//            completion(.success(getPhotosResponse))
//        case .failure:
//            completion(.failure(.network))
//        }
//    }
//
//    func loadPhoto(imageUrl: String, completion: @escaping (Result<UIImage, NetworkServiceError>) -> Void) {
//        switch networkCompletion {
//        case .success:
//            completion(.success(resultImage))
//        case .failure:
//            completion(.failure(.network))
//        }
//}
//    
//}
