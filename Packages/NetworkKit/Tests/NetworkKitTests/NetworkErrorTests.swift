//
//  NetworkErrorTests.swift
//  
//
//  Created by Mo Ahmad on 01/05/2023.
//

import XCTest
@testable import NetworkKit

final class NetworkErrorTests: XCTestCase {
    func test_NetworkError_Connectivity() {
        // Given
        let sut = NetworkError.connectivity

        // Then
        XCTAssertEqual(sut.errorDescription, "Oops something went wrong")
        XCTAssertEqual(sut.recoverySuggestion, "Maybe check your internet connection?")
    }

    func test_NetworkError_InvalidData() {
        // Given
        let sut = NetworkError.invalidData

        // Then
        XCTAssertEqual(sut.errorDescription, "Invalid Data Error")
        XCTAssertEqual(sut.recoverySuggestion, "Please try again")
    }

    func test_NetworkError_InvalidResponse() {
        // Given
        let sut = NetworkError.invalidResponse

        // Then
        XCTAssertEqual(sut.errorDescription, "Invalid Response Error")
        XCTAssertEqual(sut.recoverySuggestion, "Please try again")
    }
}
