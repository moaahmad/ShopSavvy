//
//  Constant.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 15/04/2023.
//

import Foundation

extension CGFloat {
    struct Image {
        private init() {}
        static let iconSize: CGFloat = 60
        static let cornerRadius: CGFloat = 8
    }
}

extension CGFloat {
    struct Button {
        private init() {}
        static let height: CGFloat = 50
    }
}

extension String {
    struct ImageAsset {
        private init() {}
        static let listBulletBelowRectangle = "list.bullet.below.rectangle"
        static let cart = "cart"
        static let plus = "plus"
        static let trashIcon = "trash.fill"
        static let star = "star.fill"
    }
}
