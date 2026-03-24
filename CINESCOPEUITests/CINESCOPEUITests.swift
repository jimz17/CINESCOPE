//
//  CINESCOPEUITests.swift
//  CINESCOPEUITests
//
//  Created by Jimmy Aguilar on 3/23/26.
//

import XCTest

final class CINESCOPEUITests: XCTestCase {

    func testAppLaunches() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.waitForExistence(timeout: 5))
    }
}
