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

    @State private var showingSettings = false

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
        .sheet(isPresented: $showingSettings) {
            ShoppingCartView(viewModel: shoppingCartViewModel)
                .presentationDetents([.medium, .large])
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
                    .onAppear {
                        productFeedViewModel.loadMoreContentIfNeeded(currentItem: product)
                    }
                }
                .listStyle(.inset)
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

    struct ToolbarSettingsButton: View {
        @Binding var showingSettings: Bool

        var body: some View {
            Button {
                showingSettings.toggle()
            } label: {
                Image(systemName: ImageAsset.settings)
                    .font(.body)
                    .fontWeight(.bold)
            }
            .accessibilityLabel("Settings button")
        }
    }
}

// MARK: - Constants

private extension ProductFeedView.ToolbarSettingsButton {
    struct ImageAsset {
        private init() {}
        static var settings: String { "gearshape" }
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
