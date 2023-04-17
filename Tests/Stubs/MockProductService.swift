//
//  MockProductService.swift
//  Tests
//
//  Created by Mo Ahmad on 17/04/2023.
//

import Combine
import Foundation
@testable import ShopSavvy

final class MockProductService: ProductServicing {
    var productResult: Result<ProductResponse, Error>?
    var fetchProductsCalledCount = 0

    init(productResult: Result<ProductResponse, Error>? = nil) {
        self.productResult = productResult
    }

    func fetchProducts(limit: Int, skip: Int) -> Future<ProductResponse, Error> {
        return Future<ProductResponse, Error> { [weak self] promise in
            guard let result = self?.productResult else { return }
            switch result {
            case .success(let response):
                self?.fetchProductsCalledCount += 1
                promise(.success(response))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }
}
