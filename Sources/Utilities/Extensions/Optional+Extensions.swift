//
//  Optional+Extensions.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 14/04/2023.
//

import Foundation

extension Optional where Wrapped == String {
    var orEmpty: String {
        self ?? ""
    }
}

extension Optional where Wrapped == Int {
    var orZero: Int {
        self ?? 0
    }
}

extension Optional where Wrapped == Double {
    var orZero: Double {
        self ?? 0.0
    }
}
