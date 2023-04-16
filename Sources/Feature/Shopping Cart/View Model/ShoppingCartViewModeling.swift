//
//  ShoppingCartViewModeling.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 15/04/2023.
//

import Foundation

protocol ShoppingCartViewModeling {
    var productsInCart: [Product] { get }
    var cartCount: Int { get }
    var subtotal: Int { get }

    func addOrRemoveProduct(_ product: Product, action: ProductFeedViewModel.CartAction)
    func productInCartCount(_ product: Product) -> Int
}
