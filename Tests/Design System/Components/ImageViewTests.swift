//
//  ImageViewTests.swift
//  Tests
//
//  Created by Mo Ahmad on 25/04/2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import ShopSavvy

final class ImageViewTests: XCTestCase {
    func test_ImageView() {
        // Given
        let sut = ImageView(imageURL: URL(string: "https://i.dummyjson.com/data/products/2/3.jpg")!).scaledToFit()

        let controller = UIHostingController(rootView: sut)

        // Then
        assertSnapshot(matching: controller, as: .image)
    }
}
