//
//  Constant.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 15/04/2023.
//

import Foundation

extension CGFloat {
    public struct Image {
        private init() {}
        public static let iconSize: CGFloat = 60
        public static let cornerRadius: CGFloat = 8
    }
}

extension CGFloat {
    public struct Button {
        private init() {}
        public static let height: CGFloat = 50
    }
}

extension String {
    public struct ImageAsset {
        private init() {}
        public static let listBulletBelowRectangle = "list.bullet.below.rectangle"
        public static let cart = "cart"
        public static let plus = "plus"
        public static let trashIcon = "trash.fill"
        public static let star = "star.fill"
    }
}
