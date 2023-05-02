//
//  MockProductService.swift
//  Tests
//
//  Created by Mo Ahmad on 17/04/2023.
//

import Combine
import Foundation
import ModelKit
@testable import ShopSavvy

final class MockProductService: ProductServicing {
    var productResult: Result<ProductResponse, Error>?
    var fetchProductsCalledCount = 0

    init(productResult: Result<ProductResponse, Error>? = nil) {
        self.productResult = productResult
    }

    func fetchProducts(limit: Int, skip: Int) async throws -> ProductResponse {
        guard let result = productResult else {
            fatalError("productResult must be set before fetchProducts is called")
        }
        switch result {
        case .success(let response):
            fetchProductsCalledCount += 1
            return response
        case .failure(let error):
            throw error
        }
    }
}
