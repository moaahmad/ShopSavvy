//
//  ImageView.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Kingfisher
import SwiftUI

struct ImageView: View {
    let imageURL: URL

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(uiColor: .secondarySystemBackground))

            KFImage(imageURL)
                .placeholder {
                    // Placeholder while downloading.
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .retry(maxCount: 3, interval: .seconds(5))
                .fade(duration: 0.25)
                .resizable()
                .layoutPriority(1)
                .frame(maxWidth: .infinity, alignment: .top)
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(imageURL: URL(string: "https://i.dummyjson.com/data/products/1/thumbnail.jpg")!)
            .scaledToFit()
    }
}
