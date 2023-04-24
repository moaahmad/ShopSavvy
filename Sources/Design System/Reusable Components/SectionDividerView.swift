//
//  SectionDividerView.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 24/04/2023.
//

import SwiftUI

struct SectionDividerView: View {
    let padding: CGFloat

    var body: some View {
        Divider()
            .foregroundColor(Color(uiColor: .tertiarySystemBackground))
            .padding(.horizontal, padding)
    }
}
