//
//  PriceInfoView.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 15/04/2023.
//

import SwiftUI

public struct PriceInfoView: View {
    private let price: Int
    private let discountPercentage: Double?
    private let font: Font

    public init(
        price: Int,
        discountPercentage: Double? = nil,
        font: Font = .callout
    ) {
        self.price = price
        self.discountPercentage = discountPercentage
        self.font = font
    }

    public var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: .Spacer.xxxs) {
            Text("£\(price)")
                .font(font)
                .fontWeight(.semibold)

            if let discount = discountPercentage {
                Text("-" + String(format: "%.0f", discount) + "%")
                    .font(font)
                    .fontWeight(.regular)
                    .foregroundColor(.red)
                    .fontWeight(.semibold)
            }
        }
    }
}

struct PriceInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PriceInfoView(price: 200, discountPercentage: 10.0)
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
    }
}
