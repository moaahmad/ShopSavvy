//
//  ProductCardViewTests.swift
//  Tests
//
//  Created by Mo Ahmad on 25/04/2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import DesignKit

final class ProductCardViewTests: XCTestCase {
    func test_ProductCardView() {
        // Given
        let sut = GeometryReader { geometry in
            ProductCardView(
                product: .init(
                    id: 123,
                    title: "iPhone 14",
                    description: "iPhone 14 has the same incredible chip that's in iPhone 13 Pro. A15 Bionic, with a 5‑core GPU, powers all the latest features and makes graphically intense games and AR apps feel ultra-fluid. An updated internal design delivers better thermal efficiency, so you can stay in the action longer.",
                    price: 1000,
                    discountPercentage: 5.0,
                    rating: 4.5,
                    stock: 10,
                    thumbnail: "https://i.dummyjson.com/data/products/2/3.jpg"
                ),
                geometry: geometry,
                index: 0,
                buttonAction: {}
            )
            .padding(.horizontal, .Spacer.sm)
        }

        let controller = UIHostingController(rootView: sut)

        // Then
        assertSnapshot(matching: controller, as: .image(on: .iPhone13(.portrait)))
    }
}
