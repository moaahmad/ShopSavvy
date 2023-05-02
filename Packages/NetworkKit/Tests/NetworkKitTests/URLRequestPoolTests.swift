//
//  URLRequestPoolTests.swift
//  Tests
//
//  Created by Mo Ahmad on 17/04/2023.
//

import XCTest
@testable import NetworkKit

final class URLRequestPoolTests: XCTestCase {
    func test_productsRequest_configuredCorrectly() {
        // Given
        let urlRequestPool = URLRequestPool()

        // When
        let sut = urlRequestPool.fetchProductsRequest(limit: 20, skip: 20)

        // Then
        XCTAssertEqual(sut.url?.scheme, "https")
        XCTAssertEqual(sut.url?.host, "dummyjson.com")
        XCTAssertEqual(sut.url?.pathComponents, ["/", "products"])
        XCTAssertEqual(sut.url?.getQueryItemValueForKey(key: "limit"), "20")
        XCTAssertEqual(sut.url?.getQueryItemValueForKey(key: "skip"), "20")
        XCTAssertEqual(sut.httpMethod, "GET")
        XCTAssertEqual(sut.timeoutInterval, 60.0)
    }
}
