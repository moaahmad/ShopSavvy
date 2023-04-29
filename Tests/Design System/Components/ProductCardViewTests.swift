//
//  ProductCardViewTests.swift
//  Tests
//
//  Created by Mo Ahmad on 25/04/2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import ShopSavvy

final class ProductCardViewTests: XCTestCase {
    func test_ProductCardView() {
        // Given
        let sut = GeometryReader { geometry in
            ProductCardView(
                product: .anyProduct(),
                geometry: geometry,
                buttonAction: {}
            )
            .padding(.horizontal, .Spacer.sm)
        }.scaledToFit()

        let controller = UIHostingController(rootView: sut)

        // Then
        assertSnapshot(matching: controller, as: .image)
    }
}
