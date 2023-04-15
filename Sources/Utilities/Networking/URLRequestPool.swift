//
//  URLRequestPool.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Foundation

protocol URLRequestPooling {
    func fetchProductsRequest() -> URLRequest
}

struct URLRequestPool: URLRequestPooling {
    func fetchProductsRequest() -> URLRequest {
        .init(method: .get, url: URLPool.productsURL())
    }
}
