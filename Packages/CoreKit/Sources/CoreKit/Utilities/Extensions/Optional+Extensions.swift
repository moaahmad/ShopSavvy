//
//  Optional+Extensions.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 14/04/2023.
//

import Foundation

extension Optional where Wrapped == String {
    public var orEmpty: String {
        self ?? ""
    }
}

extension Optional where Wrapped == Int {
    public var orZero: Int {
        self ?? 0
    }
}

extension Optional where Wrapped == Double {
    public var orZero: Double {
        self ?? 0.0
    }
}
