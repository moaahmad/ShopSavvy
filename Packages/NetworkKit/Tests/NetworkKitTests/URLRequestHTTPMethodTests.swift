//
//  URLRequestHTTPMethodTests.swift
//  
//
//  Created by Mo Ahmad on 01/05/2023.
//

import XCTest
@testable import NetworkKit

final class URLRequestHTTPMethodTests: XCTestCase {
    func test_URLRequest_GetMethod() {
        // Given
        let sut = URLRequest(
            method: .get,
            url: URL(string: "http://any-url.com")!
        )

        // Then
        XCTAssertEqual(sut.httpMethod, "GET")
        XCTAssertEqual(sut.url?.absoluteString, "http://any-url.com")
    }

    func test_URLRequest_PostMethod() {
        // Given
        let sut = URLRequest(
            method: .post,
            url: URL(string: "http://any-url.com")!
        )

        // Then
        XCTAssertEqual(sut.httpMethod, "POST")
        XCTAssertEqual(sut.url?.absoluteString, "http://any-url.com")
    }

    func test_URLRequest_PutMethod() {
        // Given
        let sut = URLRequest(
            method: .put,
            url: URL(string: "http://any-url.com")!
        )

        // Then
        XCTAssertEqual(sut.httpMethod, "PUT")
        XCTAssertEqual(sut.url?.absoluteString, "http://any-url.com")
    }

    func test_URLRequest_PatchMethod() {
        // Given
        let sut = URLRequest(
            method: .patch,
            url: URL(string: "http://any-url.com")!
        )

        // Then
        XCTAssertEqual(sut.httpMethod, "PATCH")
        XCTAssertEqual(sut.url?.absoluteString, "http://any-url.com")
    }

    func test_URLRequest_DeleteMethod() {
        // Given
        let sut = URLRequest(
            method: .delete,
            url: URL(string: "http://any-url.com")!
        )

        // Then
        XCTAssertEqual(sut.httpMethod, "DELETE")
        XCTAssertEqual(sut.url?.absoluteString, "http://any-url.com")
    }
}
