//
//  UserDefaultsServiceTest.swift
//  FinalProjectTests
//
//  Created by Антон Сафронов on 30.07.2021.
//

import XCTest

class UserDefaultsServiceTest: XCTestCase {
    
    let userDefaultsServiceTest = UserDefaultsService()
    
    func testThatServiceCorrectSavesDataForKey() {
    //arrange
        let value = "value"
    //act
        userDefaultsServiceTest.addCurrentQuery(query: value)
        let result = userDefaultsServiceTest.getCurrentQuery()
    //assert
        XCTAssertEqual(value, result)
    }
    
    func testThatServiceCleansData() {
    //arrange
        let value = "value"
        let expectindValue = ""
    //act
        userDefaultsServiceTest.addCurrentQuery(query: value)
        userDefaultsServiceTest.clearCurrentQuery()
        let result = userDefaultsServiceTest.getCurrentQuery()
    //assert
        XCTAssertEqual(result, expectindValue)
    }
}




