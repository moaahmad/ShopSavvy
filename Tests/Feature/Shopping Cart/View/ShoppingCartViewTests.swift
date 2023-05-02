//
//  ShoppingCartViewTests.swift
//  Tests
//
//  Created by Mo Ahmad on 25/04/2023.
//

import Combine
import ModelKit
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ShopSavvy

final class ShoppingCartViewTests: XCTestCase {
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

extension ShoppingCartViewTests {
    func test_ShoppingCartView_EmptyState() {
        // Given
        let sut = ShoppingCartView(viewModel: ShoppingCartViewModel())

        let controller = UIHostingController(rootView: sut)

        // Then
        assertSnapshot(matching: controller, as: .image(on: .iPhone13(.portrait)))
    }

    func test_ShoppingCartViewInNavigationStack_EmptyState() {
        // Given
        let sut = NavigationStack {
            ShoppingCartView(viewModel: ShoppingCartViewModel())
        }

        let controller = UIHostingController(rootView: sut)

        // Then
        assertSnapshot(matching: controller, as: .image(on: .iPhone13(.portrait)))
    }

    func test_ShoppingCartViewInNavigationStack_ProductsInCart() {
        // Given
        let viewModel = ShoppingCartViewModel()
        let exp = expectation(description: #function)
        viewModel.addOrRemoveProduct(Product.anyProduct(), action: .add)

        viewModel.$productsInCart
            .receive(on: DispatchQueue.main)
            .sink { _ in
                exp.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)

        let sut = NavigationStack {
            ShoppingCartView(viewModel: viewModel)
        }

        let controller = UIHostingController(rootView: sut)

        // Then
        assertSnapshot(matching: controller, as: .image(on: .iPhone13(.portrait)))
    }
}
