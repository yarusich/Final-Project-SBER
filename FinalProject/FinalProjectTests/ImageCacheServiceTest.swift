//
//  ImageCacheServiceTest.swift
//  FinalProjectTests
//
//  Created by Антон Сафронов on 30.07.2021.
//

import XCTest

class ImageCacheServiceTest: XCTestCase {

    let imageCacheServiceTest: ImageCacheService = .shared
    func testThatServiceCorrectSavingImageForKey() {
        //arrange
        let key = "key"
        let image = UIImage(systemName: "heart")!
        let returnedImage = UIImage(systemName: "heart")!
        
        //act
        imageCacheServiceTest.setImage(image: image, key: key)
        let result = imageCacheServiceTest.getImage(key: key)
        
        //assert
        XCTAssertEqual(result, returnedImage)
    }
}
