//
//  ProductCardView.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 14/04/2023.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product
    let viewModel: ShoppingCartViewModeling
    let geometry: GeometryProxy

    var body: some View {
        VStack(alignment: .leading, spacing: .Spacer.xxs) {
            if let imageURL = product.thumbnailURL {
                ImageView(imageURL: imageURL)
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: geometry.size.width - .Spacer.lg,
                        height: geometry.size.width / 2
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: .Image.cornerRadius)
                    )
                    .padding(.bottom, .Spacer.xxs)
            }

            HStack {
                Text(product.title.orEmpty)
                    .font(.body)
                    .fontWeight(.semibold)

                Spacer()

                Button {
                    viewModel.addOrRemoveProduct(product, action: .add)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                } label: {
                    Image(systemName: ImageAsset.plus)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .buttonStyle(BorderedButtonStyle())
                .layoutPriority(1)
            }

            Text(product.description.orEmpty)
                .font(.footnote)
                .foregroundColor(.secondary)

            RatingView(rating: product.rating.orZero)

            PriceInfoView(
                price: product.price.orZero,
                discountPercentage: product.discountPercentage
            )
        }
        .padding(.vertical, .Spacer.xxs)
    }
}

// MARK: - Constants

private extension ProductCardView {
    struct ImageAsset {
        private init() {}
        static var plus: String { "plus" }
    }
}

// MARK: - Previews

struct ProductCardView_Previews: PreviewProvider {
    final class PreviewCartViewModel: ShoppingCartViewModeling {
        var subtotal: Int = 0
        var cartCount: Int = 0
        var productsInCart: [Product] = []

        func addOrRemoveProduct(_ product: Product, action: ProductFeedViewModel.CartAction) {}
        func productInCartCount(_ product: Product) -> Int { 0 }
    }

    static var previews: some View {
        GeometryReader { geometry in
            ProductCardView(
                product: Product(),
                viewModel: PreviewCartViewModel(),
                geometry: geometry
            )
        }
    }
}
