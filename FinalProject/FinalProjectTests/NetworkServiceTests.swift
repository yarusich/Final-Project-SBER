//
//  NetworkServiceTests.swift
//  FinalProjectUITests
//
//  Created by Антон Сафронов on 29.07.2021.
//

import XCTest

class NetworkServiceTests: XCTestCase {

    var sut: PhotoNetworkServiceProtocol!
    let testError = NetworkServiceError.network
    var response: GetPhotosResponse!
    var image: String!
    var photo: [PhotoDTO]!

    override func setUp() {
        super.setUp()
        photo = [PhotoDTO]()
        response = GetPhotosResponse(results: photo)
        image = "https://storage.googleapis.com/csgoassist/mirage.jpg"
        sut = NetworkService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }


    func testResonce() {
        let expectation1 = expectation(description: "Fail")

        sut.searchPhotos(currentPage: "1", searching: "Cat") { result in
            switch result {
            case .success(let photo):
                XCTAssertNotNil(photo)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation1.fulfill()
        }
        waitForExpectations(timeout: 10,handler: nil)
    }

    func testLoadReturnError() {
        let expectation2 = expectation(description: "Failur")

        sut.loadPhoto(imageUrl: image) { result in
            switch result {
            case .success(let imageResult):
                XCTAssertNotNil(imageResult)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation2.fulfill()
        }
        waitForExpectations(timeout: 10,handler: nil)
    }
}
