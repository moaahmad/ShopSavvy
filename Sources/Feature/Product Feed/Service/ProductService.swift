//
//  ProductService.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Foundation
import ModelKit
import NetworkKit

protocol ProductServicing {
    func fetchProducts(limit: Int, skip: Int) async throws -> ProductResponse
}

struct ProductService: ProductServicing {
    // MARK: - Properties

    private let client: HTTPClient
    private let urlRequestPool: URLRequestPooling

    // MARK: - Initializer

    init(
        client: HTTPClient = URLSession.shared,
        urlRequestPool: URLRequestPooling = URLRequestPool()
    ) {
        self.client = client
        self.urlRequestPool = urlRequestPool
    }

    // MARK: - ProductServicing Functions

    func fetchProducts(limit: Int, skip: Int) async throws -> ProductResponse {
        let request = urlRequestPool.fetchProductsRequest(limit: limit, skip: skip)

        guard let (data, response) = try? await client.performRequest(request) else {
            throw NetworkError.connectivity
        }

        guard response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(ProductResponse.self, from: data)
        } catch {
            throw NetworkError.invalidData
        }
    }
}

