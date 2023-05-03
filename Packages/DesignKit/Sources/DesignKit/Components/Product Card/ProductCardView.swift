//
//  ProductCardView.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 14/04/2023.
//

import CoreKit
import ModelKit
import SwiftUI

public struct ProductCardView: View {
    let product: Product
    let geometry: GeometryProxy
    let index: Int
    let buttonAction: () -> Void

    public init(
        product: Product,
        geometry: GeometryProxy,
        index: Int,
        buttonAction: @escaping () -> Void
    ) {
        self.product = product
        self.geometry = geometry
        self.index = index
        self.buttonAction = buttonAction
    }

    public var body: some View {
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
                    .accessibilityIdentifier(AccessibilityIdentifier.imageID(index))
            }

            HStack {
                Text(product.title.orEmpty)
                    .font(.body)
                    .fontWeight(.semibold)
                    .accessibilityLabel(product.title.orEmpty)
                    .accessibilityIdentifier(AccessibilityIdentifier.titleID(index))

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
                .accessibilityLabel(AccessibilityLabel.productTitleIdentifier(product))
                .accessibilityIdentifier(AccessibilityIdentifier.buttonID(index))
            }

            Text(product.description.orEmpty)
                .font(.footnote)
                .foregroundColor(.secondary)
                .accessibilityLabel(product.description.orEmpty)
                .accessibilityIdentifier(AccessibilityIdentifier.descriptionID(index))

            RatingView(rating: product.rating.orZero)
                .accessibilityLabel(AccessibilityLabel.productRatingIdentifier(product))
                .accessibilityIdentifier(AccessibilityIdentifier.ratingID(index))

            PriceInfoView(
                price: product.price.orZero,
                discountPercentage: product.discountPercentage
            )
            .accessibilityLabel(AccessibilityLabel.productPriceInfoIdentifier(product))
            .accessibilityIdentifier(AccessibilityIdentifier.priceID(index))
        }
        .padding(.vertical, .Spacer.xxs)
    }
}

// MARK: - Accessibility Strings

private extension ProductCardView {
    struct AccessibilityIdentifier {
        private init() {}

        static func imageID(_ index: Int) -> String {
            "product-card-view-image-\(index)"
        }

        static func titleID(_ index: Int) -> String {
            "product-card-view-title-\(index)"
        }

        static func descriptionID(_ index: Int) -> String {
            "product-card-view-description-\(index)"
        }

        static func buttonID(_ index: Int) -> String {
            "product-card-view-button-\(index)"
        }

        static func ratingID(_ index: Int) -> String {
            "product-card-view-rating-\(index)"
        }

        static func priceID(_ index: Int) -> String {
            "product-card-view-price-info-\(index)"
        }
    }

    struct AccessibilityLabel {
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
