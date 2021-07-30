//
//  FinalUiTest.swift
//  FinalProjectUITests
//
//  Created by Антон Сафронов on 30.07.2021.
//

import XCTest

class FinalUiTest: XCTestCase {

    func testSearch() throws {
            // UI tests must launch the application that they test.
            let app = XCUIApplication()
            app.launch()
            
            let navigationBar = app.navigationBars["FinalProject.MainView"]
            
            let searchFieldElement = navigationBar.children(matching: .searchField).element
            searchFieldElement.tap()
            searchFieldElement.typeText("dogs")
            
            app.keyboards.buttons["Search"].tap()
                    
            let secondDog = app
                .collectionViews
                .children(matching: .cell)
                .element(boundBy: 1)
                .children(matching: .other)
                .element
            
            secondDog.tap()
            sleep(1)
            
            app.buttons["Heart"].tap()
            app.buttons["Back"].tap()
            
            sleep(1)
            
            app.buttons["Favorites"].tap()
            
            let favoriteDog = app
                .collectionViews
                .children(matching: .cell)
                .element(boundBy: 0)
            
            XCTAssert(favoriteDog.exists)
            
            let screenshot = app.screenshot()
            let att = XCTAttachment(screenshot: screenshot)
            att.lifetime = .keepAlways
            add(att)
                    
        }

}
