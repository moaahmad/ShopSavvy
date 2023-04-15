//
//  ProductFeedView.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import SwiftUI

struct ProductFeedView<ViewModel: ProductFeedViewModeling & ObservableObject>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var showingShoppingCart = false

    var body: some View {
        ContentView(viewModel: viewModel)
            .animation(.easeInOut, value: viewModel.isLoading)
            .onAppear { viewModel.loadFeed() }
            .navigationTitle("Products")
            .sheet(isPresented: $showingShoppingCart) {
                ShoppingCartView(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ToolbarCartButton(
                        viewModel: viewModel,
                        showingShoppingCart: $showingShoppingCart
                    )
                    .disabled(viewModel.isLoading)
                }
            }
    }
}

// MARK: - Subviews

extension ProductFeedView {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel

        var body: some View {
            GeometryReader { geometry in
                List(viewModel.products, id: \.id) { product in
                    ProductCardView(
                        product: product,
                        viewModel: viewModel,
                        geometry: geometry
                    )
                }
                .listStyle(.grouped)
                .refreshable { viewModel.loadFeed() }
                .overlay(alignment: .top) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .padding(.top, .Spacer.md)
                    }
                }
            }
        }
    }

    struct ToolbarCartButton: View {
        @ObservedObject var viewModel: ViewModel
        @Binding var showingShoppingCart: Bool

        var body: some View {
            Button {
                showingShoppingCart.toggle()
            } label: {
                ZStack {
                    Image(systemName: ImageAsset.cart)
                        .font(.body)
                        .fontWeight(.semibold)
                    if viewModel.cartCount != 0 {
                        Text(String(viewModel.cartCount))
                            .font(.caption2)
                            .padding(.Spacer.xxs / 2)
                            .background(Color.red)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .offset(x: 14, y: -14)
                    }
                }
                .animation(.spring(), value: viewModel.cartCount)
            }
        }
    }
}

// MARK: - Constants

private extension ProductFeedView {
    struct ImageAsset {
        private init() {}
        static var cart: String { "cart" }
    }
}

// MARK: - Previews

struct ProductFeedView_Previews: PreviewProvider {
    final class PreviewViewModel: ProductFeedViewModeling & ObservableObject {
        var productsInCart: [Product] = []
        var subtotal: Int = 0
        var cartCount: Int = 0
        var products: [Product] = []
        var isLoading: Bool = false

        func loadFeed() {}
        func addOrRemoveProduct(_ product: Product, action: ProductFeedViewModel.CartAction) {}
        func productInCartCount(_ product: Product) -> Int { 0 }
    }

    static var previews: some View {
        ProductFeedView(viewModel: PreviewViewModel())
    }
}
