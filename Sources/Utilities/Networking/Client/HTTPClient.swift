//
//  HTTPClient.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Foundation

protocol HTTPClient {
    func performRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

extension URLSession: HTTPClient {
    private struct UnexpectedValuesRepresentation: Error {}

    func performRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw UnexpectedValuesRepresentation()
        }
        return (data, httpResponse)
    }
}
