//
//  Error.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Foundation

enum NetworkError: Error {
    case connectivity
    case invalidResponse
    case invalidData
}
