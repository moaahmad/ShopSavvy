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
    var title: String { get }
    var emptyText: String { get }
    var subtotalTitleText: String { get }
    var subtotalValueText: String { get }
    var buyNowText: String { get }
    var buyNowAlertText: AlertText { get }

    func addOrRemoveProduct(_ product: Product, action: CartAction)
    func productInCartQuantity(_ product: Product) -> String
    func resetShoppingCart()
}
