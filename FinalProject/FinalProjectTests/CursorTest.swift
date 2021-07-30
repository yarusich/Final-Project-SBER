//
//  CursorTest.swift
//  FinalProjectTests
//
//  Created by Антон Сафронов on 30.07.2021.
//

import XCTest

class CursorTest: XCTestCase {

    let cursor = Cursor()
    
    func testThatClassReturnCorrectValue() {
        //arrange
        let returnedValue = "1"
        //act
        let result = cursor.nextPage()
        //assert
        XCTAssertEqual(result, returnedValue)
    }
    
    func testThatClassClearsCurrentValue() {
        //arrange
        let returnedValue = "1"
        //act
        for _ in 0...2 {
            let _ = cursor.nextPage()
        }
        cursor.zeroPage()
        let result = cursor.nextPage()
        //assert
        XCTAssertEqual(result, returnedValue)
        
    }
}
