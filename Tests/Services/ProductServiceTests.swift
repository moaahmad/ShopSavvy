//
//  ProductServiceTests.swift
//  Tests
//
//  Created by Mo Ahmad on 17/04/2023.
//

import Combine
import XCTest
@testable import ShopSavvy

final class ProductServiceTests: XCTestCase {
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

// MARK: - Load Feed Failure Tests

extension ProductServiceTests {
    func test_fetchProducts_onSuccessWithNon200Code_returnsError() {
        // Given
        let (sut, client) = makeSUT()

        var returnedError: ResponseError?
        let exp = expectation(description: "Wait for fetch completion")

        // When
        sut.fetchProducts(limit: 20, skip: 20)
            .sink { completion in
                switch completion {
                case .failure(let error as ResponseError):
                    returnedError = error
                    exp.fulfill()
                default:
                    XCTFail("Expected fetch to fail with invalidResponse error")
                }
            } receiveValue: { result in
                XCTFail("Expected fetch to fail with invalidResponse error")
            }
            .store(in: &cancellables)

        client.complete(withStatusCode: 100, data: .init())
        wait(for: [exp], timeout: 1.0)

        // Then
        XCTAssertEqual(returnedError, .invalidResponse)
    }

    func test_fetchProducts_onSuccessWithNonInvalidData_returnsError() {
        // Given
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Wait for fetch completion")
        var returnedError: ResponseError?

        // When
        sut.fetchProducts(limit: 20, skip: 20)
            .sink { completion in
                switch completion {
                case .failure(let error as ResponseError):
                    returnedError = error
                    exp.fulfill()
                default:
                    XCTFail("Expected fetch to fail with invalidData error")
                }
            } receiveValue: { result in
                XCTFail("Expected fetch to fail with invalidData error")
            }
            .store(in: &cancellables)

        client.complete(withStatusCode: 200, data: MockServer.loadLocalJSON("BadJSON"))
        wait(for: [exp], timeout: 1.0)

        // Then
        XCTAssertEqual(returnedError, .invalidData)
    }

    func test_fetchProducts_onFailure_returnsError() {
        // Given
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Wait for fetch completion")
        var returnedError: Error?

        // When
        sut.fetchProducts(limit: 20, skip: 20)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    returnedError = error
                    exp.fulfill()
                default:
                    XCTFail("Expected fetch to fail with invalidData error")
                }
            } receiveValue: { result in
                XCTFail("Expected fetch to fail with error")
            }
            .store(in: &cancellables)

        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)

        wait(for: [exp], timeout: 1.0)

        // Then
        XCTAssertNotNil(returnedError)
    }
}

// MARK: - Load Feed Success Tests

extension ProductServiceTests {
    func test_fetchRecipes_onSuccess_returnsRecipes() {
        // Given
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Wait for fetch completion")
        var returnedProducts: [Product] = []

        // When
        sut.fetchProducts(limit: 20, skip: 20)
            .sink { _ in } receiveValue: { response in
                returnedProducts = response.products
                exp.fulfill()
            }
            .store(in: &cancellables)

        let data = MockServer.loadLocalJSON("Products")
        let expectedResponse = try! JSONDecoder().decode(ProductResponse.self, from: data)
        client.complete(withStatusCode: 200, data: data)
        wait(for: [exp], timeout: 1.0)

        // Then
        XCTAssertEqual(returnedProducts, expectedResponse.products)
    }
}

// MARK: - Make SUT

private extension ProductServiceTests {
    func makeSUT() -> (sut: ProductService, client: HTTPClientSpy)  {
        let client = HTTPClientSpy()
        let sut = ProductService(client: client)
        return (sut, client)
    }
}
