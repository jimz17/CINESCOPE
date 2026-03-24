//
//  CINESCOPEUITestsLaunchTests.swift
//  CINESCOPEUITests
//
//  Created by Jimmy Aguilar on 3/23/26.
//

import XCTest

final class CINESCOPEUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.waitForExistence(timeout: 5))
    }
}
