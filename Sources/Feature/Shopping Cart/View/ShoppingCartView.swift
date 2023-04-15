//
//  ShoppingCartView.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 14/04/2023.
//

import SwiftUI

struct ShoppingCartView<ViewModel: ShoppingCartViewModeling & ObservableObject>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading) {
                    // Header View
                    ShoppingCartHeaderView(subtotal: viewModel.subtotal)

                    if viewModel.productsInCart.isEmpty {
                        // Empty State
                        Text("No products are currently in your cart")
                    } else {
                        // Content View
                        LazyVStack(alignment: .leading) {
                            ForEach(
                                Array(zip(viewModel.productsInCart.indices, viewModel.productsInCart)),
                                id: \.0
                            ) { index, product in
                                ShoppingCartCardView(
                                    product: product,
                                    count: viewModel.productInCartCount(product),
                                    onIncrement: { viewModel.addOrRemoveProduct(product, action: .add) },
                                    onDecrement: { viewModel.addOrRemoveProduct(product, action: .remove) }
                                )
                                .padding(.vertical, .Spacer.xxs)

                                if index != viewModel.productsInCart.count - 1 {
                                    Divider()
                                        .foregroundColor(Color(uiColor: .tertiarySystemBackground))
                                        .padding(.horizontal, .Spacer.sm)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, .Spacer.lg)

            // Buy Now CTA
            BuyNowButtonView(viewModel: viewModel)
        }
        .animation(.default, value: viewModel.productsInCart)
        .padding(.horizontal, .Spacer.sm)
    }
}

// MARK: - Subviews

private extension ShoppingCartView {
    struct ShoppingCartHeaderView: View {
        let subtotal: Int

        var body: some View {
            HStack(spacing: .Spacer.xxxs) {
                Text("Subtotal")
                    .font(.title2)
                    .fontWeight(.medium)

                Text("£\(subtotal)")
                    .font(.title2)
                    .fontWeight(.heavy)
            }
            .padding(.bottom, .Spacer.xs)
        }
    }

    struct ShoppingCartCardView: View {
        let product: Product
        let count: Int
        let onIncrement: () -> Void
        let onDecrement: () -> Void

        var body: some View {
            HStack {
                if let imageURL = product.thumbnailURL {
                    ImageView(imageURL: imageURL)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape( Circle() )
                }

                VStack(alignment: .leading) {
                    HStack {
                        Text(product.title.orEmpty)
                            .lineLimit(1)
                            .font(.callout)
                            .fontWeight(.semibold)
                        
                        Text("(x\(count))")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }

                    PriceInfoView(
                        price: product.price.orZero,
                        discountPercentage: product.discountPercentage,
                        font: .footnote
                    )
                }

                Stepper(
                    "",
                    onIncrement: {
                        onIncrement()
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }, onDecrement: {
                        onDecrement()
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                )
            }
        }
    }

    struct BuyNowButtonView: View {
        @ObservedObject var viewModel: ViewModel

        var body: some View {
            Button {
                print("Buy now tapped")
            } label: {
                Text("Buy Now")
                    .font(.body)
                    .fontWeight(.semibold)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: .Image.cornerRadius)
                            .stroke(.primary, lineWidth: 1)
                    )
            }
            .foregroundColor(!viewModel.productsInCart.isEmpty ? .primary : .gray.opacity(0.8))
            .disabled(viewModel.productsInCart.isEmpty)
        }
    }
}

// MARK: - Previews

struct ShoppingCartView_Previews: PreviewProvider {
    final class PreviewViewModel: ShoppingCartViewModeling & ObservableObject {
        var productsInCart: [Product] = []
        var subtotal: Int = 0
        var cartCount: Int = 0

        func addOrRemoveProduct(_ product: Product, action: ProductFeedViewModel.CartAction) {}
        func productInCartCount(_ product: Product) -> Int { 0 }
    }

    static var previews: some View {
        ShoppingCartView(viewModel: PreviewViewModel())
    }
}
