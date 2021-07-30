//
//  NetworkServiceTests.swift
//  FinalProjectUITests
//
//  Created by Антон Сафронов on 29.07.2021.
//

import XCTest

class NetworkServiceTests: XCTestCase {
    
    func testThatServiceReturnsModelData() {
        //arrange
        let model = [PhotoDTO]()
        
        let getPhotosResponse = GetPhotosResponse(results: model)
        
        let resultImage = UIImage(systemName: "heart")!
        let networkServiceMock: PhotoNetworkServiceProtocol
        networkServiceMock = NetworkServiceMock(getPhotosResponse: getPhotosResponse, resultImage: resultImage, networkCompletion: .success)
        
        let networkService = NetworkService()
        let expectationNetwork = expectation(description: "Success and network error")
        let expectationCount = resultImage
        //act
        networkServiceMock.searchPhotos { result in
            switch result {
            case
            }
            
        }
        
        //assert
    }

}
