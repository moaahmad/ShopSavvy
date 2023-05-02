//
//  HTTPClientSpy.swift
//  Tests
//
//  Created by Mo Ahmad on 17/04/2023.
//

import Foundation
import NetworkKit
@testable import ShopSavvy

final class HTTPClientSpy: HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    // MARK: - Properties

    private(set) var requests: [URLRequest] = []
    private let result: Result

    // MARK: - Initializer

    init(result: Result) {
        self.result = result
    }

    // MARK: - Functions

    func performRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        self.requests.append(request) 
        return try result.get()
    }
}
