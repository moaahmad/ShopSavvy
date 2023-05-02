//
//  ProductResponse.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Foundation

public struct ProductResponse: Decodable {
    public var products: [Product]
    public var total: Int
    public var skip: Int
    public var limit: Int
}
