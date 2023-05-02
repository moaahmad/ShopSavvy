//
//  UITestCase.swift
//  UITests
//
//  Created by Mo Ahmad on 02/05/2023.
//

import XCTest

class UITestCase: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()

        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["-uitesting"]
    }

    override func tearDownWithError() throws {
        app.terminate()
        try super.tearDownWithError()
    }

    func launchApp() {
        app.launch()
    }
}
