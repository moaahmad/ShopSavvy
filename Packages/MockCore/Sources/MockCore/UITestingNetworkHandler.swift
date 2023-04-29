//
//  UITestingNetworkHandler.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 28/04/2023.
//

import Foundation

public final class UITestingNetworkHandler {
    public static func register() {
        URLProtocol.registerClass(UITestingURLProtocol.self)

        UITestingURLProtocol.responseProvider = { request in
            guard let url = request.url else { fatalError() }
            switch (url.host, url.path) {
            case ("dummyjson.com", "/products"):
                let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
                let data = MockServer.loadLocalJSON(.products)
                return .success(UITestingURLProtocol.ResponseData(response: response, data: data))
            default:
                fatalError("Unhandled")
            }
        }
    }
}
