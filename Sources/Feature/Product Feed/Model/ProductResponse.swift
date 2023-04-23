//
//  ProductResponse.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Foundation

struct ProductResponse: Decodable {
    var products: [Product]
    var total: Int
    var skip: Int
    var limit: Int
}
