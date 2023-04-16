//
//  ProductFeedViewModel.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Combine
import Foundation

final class ProductFeedViewModel: ProductFeedViewModeling & ObservableObject {
    enum CartAction {
        case add
        case remove
    }

    // MARK: - Properties

    private static let pageLimit = 20
    private let service: ProductServicing

    private var cancellables: Set<AnyCancellable> = .init()
    private var isFetching = false
    private var isRefreshing = false
    private var isLastPage = false

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
}

// MARK: - ProductFeedViewModeling Functions

extension ProductFeedViewModel {
    func loadFeed() {
        isRefreshing = true
        fetchProducts { [weak self] in
            self?.isRefreshing = false
        }
    }

    func loadMoreContentIfNeeded(currentItem: Product?) {
        guard let currentItem else { return }
        let thresholdIndex = products.index(products.endIndex, offsetBy: -4)
        if let lastIndex = products.firstIndex(where: { $0.id == currentItem.id }),
            lastIndex >= thresholdIndex {
            fetchProducts()
        }
    }
}

// MARK: - ShoppingCartViewModeling Functions

extension ProductFeedViewModel {
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
    func fetchProducts(completion: (() -> Void)? = nil) {
        guard !isFetching && !isLastPage else {
            return
        }
        isFetching = true

        let response = service.fetchProducts(
            limit: Self.pageLimit,
            skip: isRefreshing ? 0 : products.count
        )

        response
            .receive(on: DispatchQueue.main)
            .map { $0.products }
            .sink { [weak self] completion in
                guard let self else { return }
                self.handleCompletion(completion: completion)
            } receiveValue: { [weak self] in
                guard let self else { return }
                self.handleResponse(products: $0)
                completion?()
            }
            .store(in: &cancellables)
    }

    func handleCompletion(completion: Subscribers.Completion<Error>) {
        // Update states
        self.isLoading = false
        self.isFetching = false
        self.isRefreshing = false

        // If there's an error, log it to the console for now
        if case let .failure(error) = completion {
            print("Error fetching recipes: \(error.localizedDescription)")
        }
    }

    func handleResponse(products: [Product]) {
        // If refreshing, we only want to see the first page results
        if self.isRefreshing { self.products = [] }
        self.products.append(contentsOf: products)

        // If we don't receive any results and there is no error
        // set isLastPage to be true so we don't paginate again
        if products.isEmpty { self.isLastPage = true }
    }
}

// MARK: - Combine Subscriptions

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
