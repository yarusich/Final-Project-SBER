//
//  BaseViewControllerTest.swift
//  FinalProjectTests
//
//  Created by Антон Сафронов on 30.07.2021.
//

import XCTest

class BaseViewControllerTest: XCTestCase {

    let sut = BaseViewController()
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    enum RequestError {
        case network
        case decodable
        case buildingURL
        case unknown
    }
    
    
    func testThatSpinnerIsShowingWhenIsLoadingIsTrue() throws {
        // arrange
        sut.isLoading = false
        sut.isLoading = true
        // act
        let result = sut.showSpinner(isShown: sut.isLoading)
        // assert
        XCTAssertTrue(result)
    }
    
    func testThatSpinnerIsNotShowingWhenIsLoadingIsFalse() throws {
        // arrange
        sut.isLoading = true
        sut.isLoading = false
        // act
        let result = sut.showSpinner(isShown: sut.isLoading)
        // assert
        XCTAssertFalse(result)
    }

    func testThatSendCorrectMessageForAlertWhenThereIsNetworkError() {
        //arrange
        let error = NetworkServiceError.network
        let expectindMessage = "Запрос упал"
        //act
        let result = sut.message(for: error)
        //assert
        XCTAssertEqual(result, expectindMessage)
    }
    
    
    func testThatSendCorrectMessageForAlertWhenThereIsDecodableError() {
        //arrange
        let error = NetworkServiceError.decodable
        let expectindMessage = "Не смогли распарсить"
        //act
        let result = sut.message(for: error)
        //assert
        XCTAssertEqual(result, expectindMessage)
    }
    
    func testThatSendCorrectMessageForAlertWhenThereIsBuildingURLError() {
        //arrange
        let error = NetworkServiceError.buildingURL
        let expectindMessage = "Ошибка в сборке url"
        //act
        let result = sut.message(for: error)
        //assert
        XCTAssertEqual(result, expectindMessage)
    }
    
    func testThatSendCorrectMessageForAlertWhenThereIsUnknownError() {
        //arrange
        let error = NetworkServiceError.unknown
        let expectindMessage = "Что-то неизвестное"
        //act
        let result = sut.message(for: error)
        //assert
        XCTAssertEqual(result, expectindMessage)
    }


}
//arrange
//act
//assert
