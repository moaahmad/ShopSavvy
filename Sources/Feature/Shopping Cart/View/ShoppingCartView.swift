//
//  ShoppingCartView.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 14/04/2023.
//

import SwiftUI

struct ShoppingCartView<ViewModel: ShoppingCartViewModeling & ObservableObject>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var showingBuyNow = false

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    // Header View
                    ShoppingCartHeaderView(viewModel: viewModel)

                    if viewModel.productsInCart.isEmpty {
                        // Empty State
                        Text(viewModel.emptyText)
                            .foregroundColor(.secondary)
                            .padding(.top, .Spacer.sm)
                    } else {
                        // Content View
                        LazyVStack(alignment: .leading) {
                            ForEach(
                                Array(zip(viewModel.productsInCart.indices, viewModel.productsInCart)),
                                id: \.0
                            ) { index, product in
                                ShoppingCartCardView(
                                    product: product,
                                    quantity: viewModel.productInCartQuantity(product),
                                    onIncrement: { viewModel.addOrRemoveProduct(product, action: .add) },
                                    onDecrement: { viewModel.addOrRemoveProduct(product, action: .remove) }
                                )
                                .padding(.vertical, .Spacer.xxs)

                                if index != viewModel.productsInCart.count - 1 {
                                    SectionDividerView(padding: .Spacer.sm)
                                }
                            }
                        }
                    }
                }
            }

            // Buy Now CTA
            SectionDividerView(padding: -.Spacer.sm)
            BuyNowButtonView(viewModel: viewModel, showingBuyNow: $showingBuyNow)
                .padding(.vertical, .Spacer.xs)
        }
        .padding(.horizontal, .Spacer.sm)
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ResetCartToolbarButtonView(viewModel: viewModel)
                    .disabled(viewModel.cartCount == 0)
            }
        }
        .alert(isPresented: $showingBuyNow) {
            Alert(
                title: Text(viewModel.buyNowAlertText.title),
                message: Text(viewModel.buyNowAlertText.message),
                primaryButton: .destructive(
                    Text(viewModel.buyNowAlertText.action)
                ) {
                    withAnimation { viewModel.resetShoppingCart() }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

// MARK: - Subviews

private extension ShoppingCartView {
    // MARK: - Shopping Cart Header

    struct ShoppingCartHeaderView: View {
        @ObservedObject var viewModel: ViewModel

        var body: some View {
            HStack(spacing: .Spacer.xxxs) {
                Text(viewModel.subtotalTitleText)
                    .font(.title2)
                    .fontWeight(.medium)

                Text(viewModel.subtotalValueText)
                    .font(.title2)
                    .fontWeight(.heavy)
            }
            .padding(.bottom, .Spacer.xs)
        }
    }

    // MARK: - Shopping Cart Card

    struct ShoppingCartCardView: View {
        let product: Product
        let quantity: String
        let onIncrement: () -> Void
        let onDecrement: () -> Void

        var body: some View {
            HStack {
                if let imageURL = product.thumbnailURL {
                    ImageView(imageURL: imageURL)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: .Image.iconSize, height: .Image.iconSize)
                        .clipShape( Circle() )
                }

                VStack(alignment: .leading, spacing: .Spacer.xxs) {
                    Text(product.title.orEmpty)
                        .font(.body)
                        .fontWeight(.semibold)

                    HStack {
                        VStack(alignment: .leading, spacing: .Spacer.xxxs) {
                            PriceInfoView(
                                price: product.price.orZero,
                                discountPercentage: product.discountPercentage,
                                font: .callout
                            )

                            Text(quantity)
                                .foregroundColor(.secondary)
                                .font(.footnote)
                        }

                        Stepper(
                            "",
                            onIncrement: {
                                withAnimation { onIncrement() }
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }, onDecrement: {
                                withAnimation { onDecrement() }
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }
                        )
                    }
                }
            }
        }
    }

    // MARK: - Buy Now Button

    struct BuyNowButtonView: View {
        @ObservedObject var viewModel: ViewModel
        @Binding var showingBuyNow: Bool

        var body: some View {
            Button {
                showingBuyNow.toggle()
            } label: {
                Text(viewModel.buyNowText)
                    .font(.body)
                    .fontWeight(.semibold)
                    .frame(height: .Button.height)
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

    // MARK: - Reset Button

    struct ResetCartToolbarButtonView: View {
        @ObservedObject var viewModel: ViewModel

        var body: some View {
            Button {
                withAnimation {
                    viewModel.resetShoppingCart()
                }
            } label: {
                Text("Reset")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, .Spacer.xxxs)
                    .padding(.horizontal, .Spacer.xxs)
                    .overlay(
                        RoundedRectangle(cornerRadius: .Image.cornerRadius)
                            .stroke(viewModel.cartCount > 0 ? .primary : .secondary, lineWidth: 1)
                    )
                    .foregroundColor(viewModel.cartCount > 0 ? .primary : .secondary)
            }
        }
    }
}

// MARK: - Previews

struct ShoppingCartView_Previews: PreviewProvider {
    final class PreviewViewModel: ShoppingCartViewModeling & ObservableObject {
        var title: String = ""
        var emptyText: String = ""
        var subtotalTitleText: String = ""
        var subtotalValueText: String = ""
        var buyNowText: String = ""
        var buyNowAlertText: AlertText = .init(title: "", message: "")
        var productsInCart: [Product] = []
        var cartCount: Int = 0

        func addOrRemoveProduct(_ product: Product, action: CartAction) {}
        func productInCartQuantity(_ product: Product) -> String { "" }
        func resetShoppingCart() {}
    }

    static var previews: some View {
        ShoppingCartView(viewModel: PreviewViewModel())
    }
}
