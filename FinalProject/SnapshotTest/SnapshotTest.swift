//
//  SnapshotTest.swift
//  SnapshotTest
//
//  Created by Антон Сафронов on 29.07.2021.
//
import SnapshotTesting
import XCTest
@testable import FinalProject

class SnapshotTest: XCTestCase {
    
    func testinfo() throws {
        let profileViewController = ProfileViewController()
        assertSnapshot(matching: profileViewController, as: .image(on: .iPhone8))
    }


}
