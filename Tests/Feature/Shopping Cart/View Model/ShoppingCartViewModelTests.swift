//
//  ShoppingCartViewModelTests.swift
//  Tests
//
//  Created by Mo Ahmad on 25/04/2023.
//

import Combine
import XCTest
@testable import ShopSavvy

final class ShoppingCartViewModelTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = .init()
    }

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
}

// MARK: - ShoppingCartViewModeling Tests

extension ShoppingCartViewModelTests {
    func test_productsInCartOnInit_isEmpty() {
        // Given
        let sut = makeSUT()

        // Then
        XCTAssertEqual(sut.productsInCart, [])
    }

    func test_cartCountOnInit_isZero() {
        // Given
        let sut = makeSUT()

        // Then
        XCTAssertEqual(sut.cartCount, 0)
    }


    func test_title_isConfiguredCorrectly() {
        // Given
        let sut = makeSUT()

        // Then
        XCTAssertEqual(sut.title, "Cart")
    }

    func test_emptyText_isConfiguredCorrectly() {
        // Given
        let sut = makeSUT()

        // Then
        XCTAssertEqual(sut.emptyText, "No products are currently in your cart")
    }

    func test_subtitleTitleText_isConfiguredCorrectly() {
        // Given
        let sut = makeSUT()

        // Then
        XCTAssertEqual(sut.subtotalTitleText, "Subtotal")
    }

    func test_subtitleValueTextOnInit_isConfiguredCorrectly() {
        // Given
        let sut = makeSUT()

        // Then
        XCTAssertEqual(sut.subtotalValueText, "£0")
    }

    func test_subtitleValueTextWithProductAdded_isConfiguredCorrectly() {
        // Given
        let sut = makeSUT()
        let exp = expectation(description: #function)
        exp.assertForOverFulfill = false

        // When
        sut.addOrRemoveProduct(Product.anyProduct(), action: .add)

        sut.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { _ in
                exp.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)

        // Then
        XCTAssertEqual(sut.subtotalValueText, "£1000")
    }

    func test_buyNowButtonText_isCorrectlyConfigured() {
        // When
        let sut = makeSUT()

        // Then
        XCTAssertEqual(sut.buyNowText, "Buy Now")
    }

    func test_addOrRemoveProduct_addWorksCorrectly() {
        // Given
        let sut = makeSUT()
        let product = Product.anyProduct()
        let exp = expectation(description: #function)
        XCTAssertEqual(sut.productsInCart.count, 0)

        // When
        sut.addOrRemoveProduct(product, action: .add)

        sut.$productsInCart
            .receive(on: DispatchQueue.main)
            .sink { _ in
                exp.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)

        // Then
        XCTAssertEqual(sut.productsInCart, [product])
        XCTAssertEqual(sut.cartCount, 1)
    }

    func test_addOrRemoveProduct_removeWorksCorrectly() {
        // Given
        let sut = makeSUT()
        let exp = expectation(description: #function)
        let product = Product.anyProduct()
        sut.productsInCart = [product]
        XCTAssertEqual(sut.productsInCart.count, 1)

        // When
        sut.addOrRemoveProduct(product, action: .remove)

        sut.$productsInCart
            .receive(on: DispatchQueue.main)
            .sink { _ in
                exp.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)

        // Then
        XCTAssertEqual(sut.productsInCart, [])
        XCTAssertEqual(sut.cartCount, 0)
    }

    func test_productInCartQuantityOnInit_returnsCorrectString() {
        // Given
        let sut = makeSUT()
        let product = Product.anyProduct()

        // When
        let quantityString = sut.productInCartQuantity(product)

        // Then
        XCTAssertEqual(quantityString, "Quantity: x0")
    }

    func test_productInCartQuantityWithProductAdded_returnsCorrectString() {
        // Given
        let sut = makeSUT()
        let product = Product.anyProduct()
        sut.addOrRemoveProduct(product, action: .add)

        // When
        let quantityString = sut.productInCartQuantity(product)

        // Then
        XCTAssertEqual(quantityString, "Quantity: x1")
    }

    func test_resetShoppingCart_clearsProducts() {
        // Given
        let sut = makeSUT()
        let exp = expectation(description: #function)
        exp.assertForOverFulfill = false
        let product = Product.anyProduct()

        sut.addOrRemoveProduct(product, action: .add)

        sut.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { _ in
                exp.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)

        XCTAssertEqual(sut.productsInCart, [product])
        XCTAssertEqual(sut.cartCount, 1)

        // When
        sut.resetShoppingCart()

        // Then
        XCTAssertEqual(sut.productsInCart, [])
        XCTAssertEqual(sut.cartCount, 0)
    }
}

// MARK: - Make SUT

private extension ShoppingCartViewModelTests {
    func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> ShoppingCartViewModel {
        let sut = ShoppingCartViewModel()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

// MARK: - Helpers

private extension Product {
    static func anyProduct() -> Product {
        .init(id: 123, title: "iPhone 14", price: 1000, stock: 10)
    }
}
