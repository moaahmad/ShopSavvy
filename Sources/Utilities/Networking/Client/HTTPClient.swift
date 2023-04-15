//
//  HTTPClient.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Foundation

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    // Change closure to Future
    func performRequest(_ request: URLRequest, completion: @escaping (Result) -> Void)
}
