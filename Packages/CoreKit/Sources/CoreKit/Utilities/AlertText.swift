//
//  AlertText.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 26/04/2023.
//

import Foundation

public struct AlertText {
    public let title: String
    public let message: String
    public let action: String

    public init(
        title: String,
        message: String,
        action: String = "ok".localized()
    ) {
        self.title = title
        self.message = message
        self.action = action
    }
}
