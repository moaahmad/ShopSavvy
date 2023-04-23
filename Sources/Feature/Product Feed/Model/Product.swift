//
//  Product.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Foundation

struct Product: Decodable {
    var id: Int?
    var title: String?
    var description: String?
    var price: Int?
    var discountPercentage: Double?
    var rating: Double?
    var stock: Int?
    var brand: String?
    var category: String?
    var thumbnail: String?
    var image: [String]?

    var thumbnailURL: URL? {
        guard let thumbnail,
              let url = URL(string: thumbnail) else {
            return nil
        }
        return url
    }

    init(
        id: Int? = nil,
        title: String? = nil,
        description: String? = nil,
        price: Int? = nil,
        discountPercentage: Double? = nil,
        rating: Double? = nil,
        stock: Int? = nil,
        brand: String? = nil,
        category: String? = nil,
        thumbnail: String? = nil,
        image: [String]? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.discountPercentage = discountPercentage
        self.rating = rating
        self.stock = stock
        self.brand = brand
        self.category = category
        self.thumbnail = thumbnail
        self.image = image
    }
}

// MARK: - Hashable Conformance

extension Product: Hashable {}
