//
//  SectionDividerView.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 24/04/2023.
//

import SwiftUI

public struct SectionDividerView: View {
    let padding: CGFloat

    public init(padding: CGFloat) {
        self.padding = padding
    }

    public var body: some View {
        Divider()
            .foregroundColor(Color(uiColor: .tertiarySystemBackground))
            .padding(.horizontal, padding)
    }
}
