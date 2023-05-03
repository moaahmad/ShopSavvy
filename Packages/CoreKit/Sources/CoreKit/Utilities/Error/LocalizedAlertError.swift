//
//  LocalizedAlertError.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 26/04/2023.
//

import Foundation

public struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError

    public var errorDescription: String? {
        underlyingError.errorDescription
    }

    public var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }

    public init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else { return nil }
        underlyingError = localizedError
    }
}
