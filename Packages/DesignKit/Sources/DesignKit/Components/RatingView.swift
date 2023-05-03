//
//  RatingView.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 14/04/2023.
//

import SwiftUI

public struct RatingView: View {
    var rating: Double
    var maxRating: Int

    public init(rating: Double, maxRating: Int = 5) {
        self.rating = rating
        self.maxRating = maxRating
    }

    public var body: some View {
        HStack(spacing: .Spacer.xxxs) {
            let stars = HStack(spacing: .zero) {
                ForEach(0..<maxRating, id: \.self) { _ in
                    Image(systemName: .ImageAsset.star)
                        .font(.caption)
                }
            }

            stars.overlay(
                GeometryReader { geometry in
                    let width = rating / CGFloat(maxRating) * geometry.size.width
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: width)
                            .foregroundColor(.yellow)
                    }
                }
                .mask(stars)
            )
            .foregroundColor(.gray.opacity(0.5))

            Text("(" + String(format: "%.2f", rating) + ")")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.yellow)
                .padding(.leading, .Spacer.xxxs)
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: 3)
    }
}
