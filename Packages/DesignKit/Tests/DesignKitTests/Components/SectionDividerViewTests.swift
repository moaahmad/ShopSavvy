//
//  SectionDividerViewTests.swift
//  Tests
//
//  Created by Mo Ahmad on 25/04/2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import DesignKit

final class SectionDividerViewTests: XCTestCase {
    func test_SectionDividerView() {
        // Given
        let sut = SectionDividerView(padding: .Spacer.sm).scaledToFit()

        let controller = UIHostingController(rootView: sut)

        // Then
        assertSnapshot(matching: controller, as: .image)
    }
}
