//
//  ProductFeedView.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import SwiftUI

struct ProductFeedView<
    ProductFeed: ProductFeedViewModeling & ObservableObject,
    ShoppingCart: ShoppingCartViewModeling & ObservableObject
>: View {
    // MARK: - Properties

    @State private var showingShoppingCart = false

    @ObservedObject var productFeedViewModel: ProductFeed
    @ObservedObject var shoppingCartViewModel: ShoppingCart

    // MARK: - View

    var body: some View {
        ContentView(
            productFeedViewModel: productFeedViewModel,
            shoppingCartViewModel: shoppingCartViewModel
        )
        .animation(.easeInOut, value: productFeedViewModel.isLoading)
        .onAppear { productFeedViewModel.loadFeed() }
        .navigationTitle(productFeedViewModel.title)
        .sheet(isPresented: $showingShoppingCart) {
            ShoppingCartView(viewModel: shoppingCartViewModel)
                .presentationDetents([.medium, .large])
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ToolbarCartButton(
                    shoppingCartViewModel: shoppingCartViewModel,
                    showingShoppingCart: $showingShoppingCart
                )
                .disabled(productFeedViewModel.isLoading)
            }
        }
    }
}

// MARK: - Subviews

extension ProductFeedView {
    struct ContentView: View {
        @ObservedObject var productFeedViewModel: ProductFeed
        @ObservedObject var shoppingCartViewModel: ShoppingCart

        var body: some View {
            GeometryReader { geometry in
                List(productFeedViewModel.products, id: \.id) { product in
                    ProductCardView(
                        product: product,
                        shoppingCartViewModel: shoppingCartViewModel,
                        geometry: geometry
                    )
                    .onAppear { productFeedViewModel.loadMoreContentIfNeeded(currentItem: product) }
                }
                .listStyle(.grouped)
                .refreshable { productFeedViewModel.loadFeed() }
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

    struct ToolbarCartButton: View {
        @ObservedObject var shoppingCartViewModel: ShoppingCart
        @Binding var showingShoppingCart: Bool

        var body: some View {
            Button {
                showingShoppingCart.toggle()
            } label: {
                ZStack {
                    Image(systemName: ImageAsset.cart)
                        .font(.body)
                        .fontWeight(.semibold)
                    if shoppingCartViewModel.cartCount != 0 {
                        Text(String(shoppingCartViewModel.cartCount))
                            .font(.caption2)
                            .padding(Constant.toolbarPadding)
                            .background(Color.red)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .offset(
                                x: Constant.toolbarImageOffset,
                                y: -Constant.toolbarImageOffset
                            )
                    }
                }
                .animation(.spring(), value: shoppingCartViewModel.cartCount)
            }
            .accessibilityLabel("Show shopping cart with \(shoppingCartViewModel.cartCount) items")
        }
    }
}

// MARK: - Constants

private extension ProductFeedView.ToolbarCartButton {
    struct Constant {
        private init() {}
        static var toolbarImageOffset: CGFloat { 14 }
        static var toolbarPadding: CGFloat { .Spacer.xxs / 2 }
    }

    struct ImageAsset {
        private init() {}
        static var cart: String { "cart" }
    }
}

// MARK: - Previews

struct ProductFeedView_Previews: PreviewProvider {
    final class PreviewViewModel: ProductFeedViewModeling & ObservableObject {
        var title: String = "Products"
        var products: [Product] = []
        var isLoading: Bool = false

        func loadFeed() {}
        func loadMoreContentIfNeeded(currentItem: Product?) {}
    }

    static var previews: some View {
        ProductFeedView(
            productFeedViewModel: PreviewViewModel(),
            shoppingCartViewModel: ShoppingCartViewModel()
        )
    }
}
