//
//  RatingViewTests.swift
//  Tests
//
//  Created by Mo Ahmad on 25/04/2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import DesignKit

final class RatingViewTests: XCTestCase {
    func test_RatingView() {
        // Given
        let sut = RatingView(rating: 3, maxRating: 5).scaledToFit()

        let controller = UIHostingController(rootView: sut)

        // Then
        assertSnapshot(matching: controller, as: .image)
    }
}
