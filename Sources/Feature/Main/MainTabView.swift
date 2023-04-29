//
//  MainTabView.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 28/04/2023.
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @StateObject var productFeedViewModel = ProductFeedViewModel()
    @StateObject var shoppingCartViewModel = ShoppingCartViewModel()

    var body: some View {
        TabView {
            // Product Feed
            NavigationStack {
                ProductFeedView(
                    productFeedViewModel: productFeedViewModel,
                    shoppingCartViewModel: shoppingCartViewModel
                )
                .errorAlert(error: $productFeedViewModel.error)
            }
            .tag(0)
            .tabItem {
                Label(productFeedViewModel.title, systemImage: "list.bullet.below.rectangle")
            }

            // Shopping Cart
            NavigationStack {
                ShoppingCartView(viewModel: shoppingCartViewModel)
            }
            .tag(1)
            .tabItem {
                Label(shoppingCartViewModel.title, systemImage: "cart")
            }
            .badge(shoppingCartViewModel.cartCount)
        }
        .environment(\.sizeCategory, sizeCategory)
    }
}
