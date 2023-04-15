//
//  ProductFeedViewModel.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Combine
import Foundation

protocol ShoppingCartViewModeling {
    var productsInCart: [Product] { get }
    var cartCount: Int { get }
    var subtotal: Int { get }

    func addOrRemoveProduct(_ product: Product, action: ProductFeedViewModel.CartAction)
    func productInCartCount(_ product: Product) -> Int
}

protocol ProductFeedViewModeling: ShoppingCartViewModeling {
    var isLoading: Bool { get }
    var products: [Product] { get }

    func loadFeed()
}

final class ProductFeedViewModel: ProductFeedViewModeling & ObservableObject {
    enum CartAction {
        case add
        case remove
    }

    // MARK: - Properties

    private let service: ProductServicing
    private var cancellables: Set<AnyCancellable> = .init()

    // MARK: - Published Properties

    @Published var shoppingCart: [Product: Int] = [:]

    @Published var isLoading: Bool = true
    @Published var products: [Product] = []

    @Published var productsInCart: [Product] = []
    @Published var cartCount: Int = 0
    @Published var subtotal: Int = 0

    // MARK: - Initializer

    init(service: ProductServicing = ProductService()) {
        self.service = service
        subscribeToShoppingCartUpdates()
    }

    func loadFeed() {
        fetchProducts()
    }

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

    func productInCartCount(_ product: Product) -> Int {
        shoppingCart[product].orZero
    }
}

// MARK: - Fetch Products

private extension ProductFeedViewModel {
    func fetchProducts() {
        service.fetchProducts()
            .receive(on: DispatchQueue.main)
            .map { $0.products }
            .sink { [weak self] completion in
                self?.isLoading = false

                // If there's an error, log it to the console for now
                if case let .failure(error) = completion {
                    print("Error fetching products: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] in
                self?.products = $0
            }
            .store(in: &cancellables)
    }
}

private extension ProductFeedViewModel {
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
            }
            .store(in: &cancellables)

        shoppingCartStream
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
