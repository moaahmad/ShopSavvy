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
    @StateObject var productFeedViewModel = ProductFeedViewModel()
    @StateObject var shoppingCartViewModel = ShoppingCartViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ProductFeedView(
                    productFeedViewModel: productFeedViewModel,
                    shoppingCartViewModel: shoppingCartViewModel
                )
                .environment(\.sizeCategory, sizeCategory)
            }
        }
    }
}
