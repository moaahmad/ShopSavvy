//
//  URLPoolTests.swift
//  Tests
//
//  Created by Mo Ahmad on 17/04/2023.
//

import XCTest
@testable import NetworkKit

final class URLPoolTests: XCTestCase {
    func test_productsURL_configuredCorrectly() {
        // Given
        let sut = URLPool.productsURL(limit: 20, skip: 20)

        // Then
        XCTAssertEqual(sut.scheme, "https")
        XCTAssertEqual(sut.host, "dummyjson.com")
        XCTAssertEqual(sut.pathComponents, ["/", "products"])
        XCTAssertEqual(sut.getQueryItemValueForKey(key: "limit"), "20")
        XCTAssertEqual(sut.getQueryItemValueForKey(key: "skip"), "20")
    }
}
