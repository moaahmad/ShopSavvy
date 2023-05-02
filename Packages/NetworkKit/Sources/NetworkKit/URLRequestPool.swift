//
//  URLRequestPool.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Foundation

public protocol URLRequestPooling {
    func fetchProductsRequest(limit: Int, skip: Int) -> URLRequest
}

public struct URLRequestPool: URLRequestPooling {
    public init() {}
    
    public func fetchProductsRequest(limit: Int, skip: Int) -> URLRequest {
        .init(
            method: .get,
            url: URLPool.productsURL(limit: limit, skip: skip)
        )
    }
}
