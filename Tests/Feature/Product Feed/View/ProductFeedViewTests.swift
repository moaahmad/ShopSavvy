//
//  ProductFeedViewTests.swift
//  Tests
//
//  Created by Mo Ahmad on 25/04/2023.
//

import Combine
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ShopSavvy

final class ProductFeedViewTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = .init()
    }

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }

    func test_ProductFeedView_LoadingState() {
        // Given
        let viewModel = ProductFeedViewModel()
        viewModel.isLoading = true
        let sut = NavigationStack {
            ProductFeedView(
                productFeedViewModel: viewModel,
                shoppingCartViewModel: ShoppingCartViewModel()
            )
        }

        let controller = UIHostingController(rootView: sut)

        // Then
        assertSnapshot(matching: controller, as: .image(on: .iPhone13(.portrait)))
    }

    func test_ProductFeedView_ProductsLoaded() {
        // Given
        let viewModel = ProductFeedViewModel()
        viewModel.isLoading = false
        viewModel.products = [.anyProduct()]
        let sut = NavigationStack {
            ProductFeedView(
                productFeedViewModel: viewModel,
                shoppingCartViewModel: ShoppingCartViewModel()
            )
        }

        let controller = UIHostingController(rootView: sut)

        // Then
        assertSnapshot(matching: controller, as: .image(on: .iPhone13(.portrait)))
    }
}
