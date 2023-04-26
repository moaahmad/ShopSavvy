//
//  ProductFeedViewModel.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Combine
import Foundation

final class ProductFeedViewModel: ProductFeedViewModeling & ObservableObject {
    // MARK: - Properties

    private static let pageLimit = 20
    private let service: ProductServicing

    private var cancellables = Set<AnyCancellable>()
    private var isFetching = false
    private var isRefreshing = false
    private var isLastPage = false

    lazy var title = "product_feed_title".localized()

    // MARK: - Published Properties

    @Published var isLoading = true
    @Published var products = [Product]()
    @Published var error: Error?

    // MARK: - Initializer

    init(service: ProductServicing = ProductService()) {
        self.service = service
    }
}

// MARK: - ProductFeedViewModeling Functions

extension ProductFeedViewModel {
    func loadFeed(isPullToRefresh: Bool = false) {
        guard products.isEmpty || isPullToRefresh else { return }
        isRefreshing = true
        Task {
            await fetchProducts { [weak self] in
                self?.isRefreshing = false
            }
        }
    }

    func loadMoreContentIfNeeded(currentItem: Product?) {
        guard let currentItem else { return }
        let thresholdIndex = products.index(products.endIndex, offsetBy: -4)
        if let lastIndex = products.firstIndex(where: { $0.id == currentItem.id }),
           lastIndex >= thresholdIndex {
            Task { await fetchProducts() }
        }
    }
}

// MARK: - Fetch Products

private extension ProductFeedViewModel {
    @MainActor private func fetchProducts(
        completion: (() -> Void)? = nil
    ) async {
        guard !isFetching && !isLastPage else { return }
        isFetching = true

        do {
            let productResponse = try await service.fetchProducts(
                limit: Self.pageLimit,
                skip: isRefreshing ? 0 : products.count
            )
            handleResponse(products: productResponse.products)
            completion?()
        } catch {
            isLoading = false
            isFetching = false
            self.error = error
        }
    }

    func handleResponse(products: [Product]) {
        // Update states
        self.isLoading = false
        self.isFetching = false

        // If refreshing, we only want to see the first page results
        if self.isRefreshing { self.products = [] }
        self.products.append(contentsOf: products)

        // If we don't receive any results and there is no error
        // set isLastPage to be true so we don't paginate again
        if products.isEmpty { self.isLastPage = true }
    }
}
