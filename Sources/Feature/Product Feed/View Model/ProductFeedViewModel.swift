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

    private var cancellables: Set<AnyCancellable> = .init()
    private var isFetching = false
    private var isRefreshing = false
    private var isLastPage = false

    lazy var title: String = "product_feed_title".localized()

    // MARK: - Published Properties

    @Published var isLoading: Bool = true
    @Published var products: [Product] = []

    // MARK: - Initializer

    init(service: ProductServicing = ProductService()) {
        self.service = service
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
            print("Error fetching products: \(error.localizedDescription)")
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
