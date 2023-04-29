//
//  TestRunnable.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 28/04/2023.
//

import Foundation

public protocol TestRunnable {
    static var isRunningTests: Bool { get }
}

public extension TestRunnable {
    static var isRunningTests: Bool {
        NSClassFromString("XCTestCase") != nil
    }
}
