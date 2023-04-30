//
//  ProductCardView.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 14/04/2023.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product
    let geometry: GeometryProxy
    let buttonAction: () -> Void

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
                    .padding(.bottom, .Spacer.xxxs)
            }

            HStack {
                Text(product.title.orEmpty)
                    .font(.body)
                    .fontWeight(.semibold)
                    .accessibilityLabel(product.title.orEmpty)

                Spacer()

                Button {
                    buttonAction()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                } label: {
                    Image(systemName: .ImageAsset.plus)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .buttonStyle(BorderedButtonStyle())
                .layoutPriority(1)
                .accessibilityLabel(AccessibilityIdentifier.productTitleIdentifier(product))
            }

            Text(product.description.orEmpty)
                .font(.footnote)
                .foregroundColor(.secondary)
                .accessibilityLabel(product.description.orEmpty)

            RatingView(rating: product.rating.orZero)
                .accessibilityLabel(AccessibilityIdentifier.productRatingIdentifier(product))

            PriceInfoView(
                price: product.price.orZero,
                discountPercentage: product.discountPercentage
            )
            .accessibilityLabel(AccessibilityIdentifier.productPriceInfoIdentifier(product))
        }
        .padding(.vertical, .Spacer.xxs)
    }
}

// MARK: - Accessibility Identifier

extension ProductCardView {
    struct AccessibilityIdentifier {
        private init() {}

        static func productTitleIdentifier(_ product: Product) -> String {
            "Add \(product.title.orEmpty) to cart"
        }

        static func productRatingIdentifier(_ product: Product) -> String {
            "Rated \(product.rating.orZero) stars"
        }

        static func productPriceInfoIdentifier(_ product: Product) -> String {
            "Price \(product.price.orZero) pounds, \(product.discountPercentage.orZero) percent off"
        }
    }
}
