//
//  UITests.swift
//  UITests
//
//  Created by Mo Ahmad on 26/04/2023.
//

import XCTest

final class UITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launchArguments = ["–uitesting"]
        app.launch()

        XCTAssert(app.navigationBars["Products"].exists)

        let tabItem = app.tabBars.buttons["Products"]
        XCTAssert(tabItem.exists)
        XCTAssertEqual(tabItem.label, "Products")
    }
}
