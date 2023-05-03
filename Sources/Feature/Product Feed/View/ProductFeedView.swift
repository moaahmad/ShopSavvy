//
//  ProductFeedView.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import DesignKit
import ModelKit
import SwiftUI

struct ProductFeedView<
    ProductFeed: ProductFeedViewModeling & ObservableObject,
    ShoppingCart: ShoppingCartViewModeling & ObservableObject
>: View {
    // MARK: - Properties

    @ObservedObject var productFeedViewModel: ProductFeed
    @ObservedObject var shoppingCartViewModel: ShoppingCart

    // MARK: - View

    var body: some View {
        ContentView(
            productFeedViewModel: productFeedViewModel,
            shoppingCartViewModel: shoppingCartViewModel
        )
        .animation(.easeInOut, value: productFeedViewModel.isLoading)
        .onAppear { productFeedViewModel.loadFeed(isPullToRefresh: false) }
        .navigationTitle(productFeedViewModel.title)
    }
}

// MARK: - Subviews

extension ProductFeedView {
    struct ContentView: View {
        @ObservedObject var productFeedViewModel: ProductFeed
        @ObservedObject var shoppingCartViewModel: ShoppingCart

        var body: some View {
            GeometryReader { geometry in
                List(
                    Array(zip(productFeedViewModel.products.indices, productFeedViewModel.products)),
                    id: \.0
                ) { index, product in
                    ProductCardView(
                        product: product,
                        geometry: geometry,
                        index: index
                    ) {
                        shoppingCartViewModel.addOrRemoveProduct(product, action: .add)
                    }
                    .onAppear {
                        productFeedViewModel.loadMoreContentIfNeeded(currentItem: product)
                    }
                }
                .listStyle(.inset)
                .refreshable { productFeedViewModel.loadFeed(isPullToRefresh: true) }
                .overlay(alignment: .top) {
                    if productFeedViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .padding(.top, .Spacer.md)
                    }
                }
            }
        }
    }
}

// MARK: - Previews

struct ProductFeedView_Previews: PreviewProvider {
    final class PreviewViewModel: ProductFeedViewModeling & ObservableObject {
        var error: Error? = nil
        var title: String = "Products"
        var products: [Product] = []
        var isLoading: Bool = false

        func loadFeed(isPullToRefresh: Bool) {}
        func loadMoreContentIfNeeded(currentItem: Product?) {}
    }

    static var previews: some View {
        ProductFeedView(
            productFeedViewModel: PreviewViewModel(),
            shoppingCartViewModel: ShoppingCartViewModel()
        )
    }
}
