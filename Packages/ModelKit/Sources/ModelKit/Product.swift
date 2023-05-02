//
//  Product.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Foundation

public struct Product: Decodable {
    public var id: Int?
    public var title: String?
    public var description: String?
    public var price: Int?
    public var discountPercentage: Double?
    public var rating: Double?
    public var stock: Int?
    public var brand: String?
    public var category: String?
    public var thumbnail: String?
    public var image: [String]?

    public var thumbnailURL: URL? {
        guard let thumbnail,
              let url = URL(string: thumbnail) else {
            return nil
        }
        return url
    }

    public init(
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
