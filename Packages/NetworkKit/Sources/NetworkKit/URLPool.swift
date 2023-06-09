//
//  URLPool.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Foundation

struct URLPool {
    private enum Endpoint: String {
        case products = "/products"
    }

    static private let scheme = "https"
    static private let host = "dummyjson.com"

    static func productsURL(limit: Int, skip: Int) -> URL {
        let parameters = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "skip", value: "\(skip)")
        ]
        return configureURL(
            scheme: scheme,
            host: host,
            path: Endpoint.products.rawValue,
            parameters: parameters
        )
    }
}

// MARK: - Private Methods

private extension URLPool {
    static func configureURL(
        scheme: String,
        host: String,
        path: String,
        parameters: [URLQueryItem]? = nil
    ) -> URL {
        let urlComponents = configureURLComponents(
            scheme: scheme,
            host: host,
            path: path,
            parameters: parameters
        )
        guard let url = urlComponents.url,
              let urlString = url.absoluteString.removingPercentEncoding,
              let fullURL = URL(string: urlString) else {
            fatalError("URL is not correctly configured")
        }
        return fullURL
    }

    static func configureURLComponents(
        scheme: String,
        host: String,
        path: String,
        parameters: [URLQueryItem]?
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = parameters
        return components
    }
}
