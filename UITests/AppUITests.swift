//
//  AppUITests.swift
//  UITests
//
//  Created by Mo Ahmad on 26/04/2023.
//

import XCTest

final class AppUITests: UITestCase {
    /// **Scenario 1: View feed of products**
    ///
    /// **GIVEN** I land on the products feed screen
    /// **WHEN** the network call succeeds
    /// **THEN** I can see a feed of product cards
    func testViewProductFeed() throws {
        launchApp()

        // Assert title and tab bar
        XCTAssert(app.navigationBars["Products"].exists)
        XCTAssert(app.tabBars.buttons["Products"].exists)

        assertProductCardSubviews(atIndex: 0)
        assertProductCardSubviews(atIndex: 1)
    }

    /// **Scenario 2: View product in cart**
    ///
    /// **GIVEN** I am on the products feed screen
    /// **WHEN** I tap the add a product to cart button AND navigate to the cart screen
    /// **THEN** I can see the product in my cart
    func testViewProductFeed_2() throws {
        launchApp()

        addProductToCart(atIndex: 0)

        navigateToCartScreen()

        XCTAssert(app.staticTexts["shopping-cart-card-view"].exists)
    }
}

// MARK: - Helpers

private extension AppUITests {
    func assertProductCardSubviews(atIndex index: Int) {
        XCTAssert(app.images["product-card-view-image-\(index)"].exists)
        XCTAssert(app.staticTexts["product-card-view-title-\(index)"].exists)
        XCTAssert(app.staticTexts["product-card-view-description-\(index)"].exists)
        XCTAssert(app.buttons["product-card-view-button-\(index)"].exists)
        XCTAssert(app.images["product-card-view-rating-\(index)"].exists)
        XCTAssert(app.staticTexts["product-card-view-price-info-\(index)"].exists)
    }

    func addProductToCart(atIndex index: Int) {
        app.buttons["product-card-view-button-\(index)"].tap()
    }

    func navigateToCartScreen() {
        app.buttons["Cart"].tap()
    }
}
