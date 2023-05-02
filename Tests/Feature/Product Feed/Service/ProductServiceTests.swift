//
//  ProductServiceTests.swift
//  Tests
//
//  Created by Mo Ahmad on 17/04/2023.
//

import CoreKit
import NetworkKit
import ModelKit
import XCTest
@testable import ShopSavvy

final class ProductServiceTests: XCTestCase {
    func test_init_doesNotStartNetworkRequest() {
        // Given
        let (_, session) = makeSUT()

        // Then
        XCTAssertEqual(session.requests.count, 0)
    }

    func test_fetchProducts_startsNetworkRequest() async throws {
        // Given
        let (sut, session) = makeSUT()

        // When
        _ = try? await sut.fetchProducts(limit: 30, skip: 0)

        // Then
        XCTAssertEqual(session.requests.count, 1)
    }
}

// MARK: - Load Feed Error Tests

extension ProductServiceTests {
    func test_fetchProducts_onFailureWithNetworkError_returnsConnectivityError() async throws {
        // Given
        let anyError = Self.anyError()
        let (sut, _) = makeSUT(result: .failure(anyError))

        // When
        do {
            _ = try await sut.fetchProducts(limit: 30, skip: 0)
            XCTFail("Expected error: \(NetworkError.connectivity)")
        } catch {
            // Then
            XCTAssertEqual(error as? NetworkError, .connectivity)
        }
    }

    func test_fetchProducts_onSuccessWithNon200Response_returnsInvalidResponseError() async throws {
        // Given
        let non200Response = Self.httpResponse(code: 400)
        let (sut, _) = makeSUT(result: .success((Data(), non200Response)))

        // When
        do {
            _ = try await sut.fetchProducts(limit: 30, skip: 0)
            XCTFail("Expected error: \(NetworkError.invalidResponse)")
        } catch {
            // Then
            XCTAssertEqual(error as? NetworkError, .invalidResponse)
        }
    }

    func test_fetchProducts_onSuccessWithInvalidData_returnsInvalidDataError() async throws {
        // Given
        let result = (MockServer.loadLocalJSON(.badJSON), Self.httpResponse(code: 200))
        let (sut, _) = makeSUT(result: .success(result))

        // When
        do {
            _ = try await sut.fetchProducts(limit: 30, skip: 0)
            XCTFail("Expected error: \(NetworkError.invalidData)")
        } catch {
            // Then
            XCTAssertEqual(error as? NetworkError, .invalidData)
        }
    }
}

// MARK: - Load Feed Success Tests

extension ProductServiceTests {
    func test_fetchProducts_onSuccess_returnsData() async throws {
        // Given
        let validData = MockServer.loadLocalJSON(.products)
        let validResponse = Self.httpResponse(code: 200)
        let (sut, _) = makeSUT(result: .success((validData, validResponse)))

        // When
        let receivedData = try await sut.fetchProducts(limit: 30, skip: 0)
        let expectedProducts = try! JSONDecoder().decode(ProductResponse.self, from: validData)

        // Then
        XCTAssertEqual(receivedData.products, expectedProducts.products)
    }
}

// MARK: - Make SUT

private extension ProductServiceTests {
    func makeSUT(
        result: Result<(Data, HTTPURLResponse), Error> = .success(anyValidResponse())
    ) -> (sut: ProductService, client: HTTPClientSpy)  {
        let client = HTTPClientSpy(result: result)
        let sut = ProductService(client: client)
        return (sut, client)
    }
}

// MARK: - Helpers

private extension ProductServiceTests {
    struct AnyError: Error {}

    static func anyError() -> Error {
        AnyError()
    }

    static func anyValidResponse() -> (Data, HTTPURLResponse) {
        (Data(), httpResponse(code: 200))
    }

    static func httpResponse(url: URL = anyURL(), code: Int) -> HTTPURLResponse {
        .init(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
    }

    static func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
}
