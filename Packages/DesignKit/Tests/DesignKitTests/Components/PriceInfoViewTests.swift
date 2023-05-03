//
//  PriceInfoViewTests.swift
//  Tests
//
//  Created by Mo Ahmad on 25/04/2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import DesignKit

final class PriceInfoViewTests: XCTestCase {
    func test_PriceInfoView() {
        // Given
        let sut = PriceInfoView(price: 100, discountPercentage: 10.0).scaledToFit()

        let controller = UIHostingController(rootView: sut)

        // Then
        assertSnapshot(matching: controller, as: .image)
    }
}
