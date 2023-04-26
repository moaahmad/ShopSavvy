//
//  ProductFeedViewModelTests.swift
//  Tests
//
//  Created by Mo Ahmad on 17/04/2023.
//

import Combine
import XCTest
@testable import ShopSavvy

final class ProductFeedViewModelTests: XCTestCase {
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

extension ProductFeedViewModelTests {
    func test_products_init_empty() {
        // Given
        let sut = makeSUT().0

        // Then
        XCTAssertEqual(sut.products.count, 0)
    }

    func test_loadFeed_isPullToRefreshFalse_noCallMade() {
        // Given
        let (sut, service) = makeSUT()
        sut.products = [.anyProduct()]

        // When
        sut.loadFeed(isPullToRefresh: false)

        // Then
        let mockService = try? XCTUnwrap(service as? MockProductService)
        XCTAssertEqual(mockService?.fetchProductsCalledCount, 0)
    }

    func test_products_loadFeed_30Values() async throws {
            // Given
            let sut = makeSUT(
                service: MockProductService(
                    productResult: .success(ProductResponse.anyProductResponse())
                )
            ).0
            let exp = expectation(description: #function)
            exp.assertForOverFulfill = false

            // When
            sut.loadFeed()

            sut.$products
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    guard !sut.products.isEmpty else { return }
                    exp.fulfill()
                }
                .store(in: &cancellables)

            await fulfillment(of: [exp])

            // Then
            XCTAssertEqual(sut.products.count, 30)
    }

    func test_loadFeed_onRefresh_ShouldCallFetchProducts() async {
        // Given
        let (sut, service) = makeSUT(
            service: MockProductService(
                productResult: .success(ProductResponse.anyProductResponse())
            )
        )
        let exp = expectation(description: #function)
        exp.assertForOverFulfill = false

        // When
        sut.loadFeed(isPullToRefresh: true)

        sut.$products
            .receive(on: DispatchQueue.main)
            .sink { _ in
                guard !sut.products.isEmpty else { return }
                exp.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 1)

        // Then
        let mockService = try? XCTUnwrap(service as? MockProductService)
        XCTAssertEqual(sut.products.count, 30)
        XCTAssertEqual(mockService?.fetchProductsCalledCount, 1)
    }

    func test_loadFeed_WhenFetchFails_ShouldNotFetchProducts() {
        // Given
        let mockService = MockProductService(
            productResult: .failure(NSError(domain: "TestError", code: -1, userInfo: nil))
        )
        let sut = makeSUT(service: mockService).0

        // When
        sut.loadFeed()

        // Then
        XCTAssertEqual(sut.products.count, 0)
        XCTAssertEqual(mockService.fetchProductsCalledCount, 0)
    }
}

// MARK: - Make SUT

extension ProductFeedViewModelTests {
    func makeSUT(service: ProductServicing = MockProductService()) -> (ProductFeedViewModel, ProductServicing) {
        let sut = ProductFeedViewModel(service: service)
        return (sut, service)
    }
}

// MARK: - Mock Data

extension ProductResponse {
    static func anyProductResponse() -> ProductResponse {
        let data = MockServer.loadLocalJSON("Products")
        return try! JSONDecoder().decode(ProductResponse.self, from: data)
    }
}
