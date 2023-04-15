//
//  ShopSavvyApp.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import SwiftUI

@main
struct ShopSavvyApp: App {
    @Environment(\.sizeCategory) var sizeCategory
    @StateObject var viewModel = ProductFeedViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ProductFeedView(viewModel: viewModel)
                    .environment(\.sizeCategory, sizeCategory)
            }
        }
    }
}
