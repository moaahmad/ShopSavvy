//
//  ShoppingCartViewModel.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 15/04/2023.
//

import Combine
import CoreKit
import Foundation
import ModelKit

final class ShoppingCartViewModel: ShoppingCartViewModeling & ObservableObject {
    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()
    private var subtotal = 0

    lazy var title = "shopping_cart_title".localized()
    lazy var emptyText = "shopping_cart_empty".localized()
    lazy var subtotalTitleText = "shopping_cart_subtotal".localized()
    lazy var subtotalValueText = "shopping_cart_value".localized(String(0))
    lazy var deleteText = "delete".localized()
    lazy var buyNowText = "shopping_cart_buy_now".localized()
    lazy var buyNowAlertText = AlertText(
        title: "shopping_cart_buy_now_alert_title".localized(),
        message: "shopping_cart_buy_now_alert_message".localized(),
        action: "shopping_cart_buy_now_alert_action".localized()
    )

    // MARK: - Published Properties

    @Published private var shoppingCart: [Product: Int] = [:]

    @Published var productsInCart = [Product]()
    @Published var cartCount = 0

    // MARK: - Initializer

    init() {
        subscribeToShoppingCartUpdates()
    }

    // MARK: - ShoppingCartViewModeling Functions

    func addOrRemoveProduct(_ product: Product, action: CartAction) {
        switch action {
        case .add:
            // Add product to cart if it's not already added
            guard let productCount = shoppingCart[product] else {
                shoppingCart[product] = 1
                return
            }
            // Only increment the product count if it's in stock
            guard let productStock = product.stock,
                productCount < productStock else {
                return
            }
            shoppingCart[product] = productCount + 1
        case .remove:
            // Decrement the product count and remove the product if its zero
            guard let productCount = shoppingCart[product] else { return }
            shoppingCart[product] = productCount == 1 ? nil : productCount - 1
        }
    }

    func deleteProductFromCart(_ product: Product) {
        shoppingCart.removeValue(forKey: product)
    }

    func productInCartQuantity(_ product: Product) -> String {
        let quantity = shoppingCart[product].orZero
        return "shopping_cart_quantity".localized(String(quantity))
    }

    func resetShoppingCart() {
        shoppingCart.removeAll()
        productsInCart = []
        cartCount = 0
    }
}

// MARK: - Combine Subscriptions

private extension ShoppingCartViewModel {
    func subscribeToShoppingCartUpdates() {
        let shoppingCartStream = $shoppingCart
            .receive(on: DispatchQueue.main)

        shoppingCartStream
            .map { $0.values.reduce(0, +) }
            .sink { [weak self] in
                self?.cartCount = $0
            }
            .store(in: &cancellables)

        shoppingCartStream
            .map { Array($0.keys) }
            .sink { [weak self] in
                self?.productsInCart = $0
            }
            .store(in: &cancellables)

        shoppingCartStream
            .map { shoppingCart in
                // Multiply the respective product's price by the quantity in the cart
                let prices = Array(shoppingCart.keys).compactMap {
                    $0.price.orZero * shoppingCart[$0].orZero
                }
                return prices.reduce(0, +)
            }
            .sink { [weak self] in
                self?.subtotal = $0
                self?.subtotalValueText = "shopping_cart_value".localized(String($0))
            }
            .store(in: &cancellables)

        shoppingCartStream
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
