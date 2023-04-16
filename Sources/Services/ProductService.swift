//
//  ProductService.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Combine
import Foundation

protocol ProductServicing {
    func fetchProducts(limit: Int, skip: Int) -> Future<ProductResponse, Error>
}

struct ProductService: ProductServicing {
    // MARK: - Properties

    private let client: HTTPClient
    private let urlRequestPool: URLRequestPooling

    // MARK: - Initializer

    init(
        client: HTTPClient = URLSessionHTTPClient(),
        urlRequestPool: URLRequestPooling = URLRequestPool()
    ) {
        self.client = client
        self.urlRequestPool = urlRequestPool
    }

    // MARK: - RecipeServicing Functions

    func fetchProducts(limit: Int, skip: Int) -> Future<ProductResponse, Error> {
        let request = urlRequestPool.fetchProductsRequest(limit: limit, skip: skip)
        return Future<ProductResponse, Error> { promise in
            client.performRequest(request) { result in
                switch result {
                case let .success((data, response)):
                    handleFetchProductsSuccessResponse(data: data, response: response, promise: promise)
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
}

private extension ProductService {
    func handleFetchProductsSuccessResponse(
        data: Data,
        response: HTTPURLResponse,
        promise: (Result<ProductResponse, Error>) -> Void
    ) {
        do {
            if response.statusCode != 200 {
                promise(.failure(ResponseError.invalidResponse))
            } else {
                let response = try JSONDecoder().decode(ProductResponse.self, from: data)
                promise(.success(response))
            }
        } catch {
            promise(.failure(ResponseError.invalidData))
        }
    }
}

