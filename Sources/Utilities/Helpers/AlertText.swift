//
//  AlertText.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 26/04/2023.
//

import Foundation

struct AlertText {
    let title: String
    let message: String
    let action: String

    init(
        title: String,
        message: String,
        action: String = "ok".localized()
    ) {
        self.title = title
        self.message = message
        self.action = action
    }
}
