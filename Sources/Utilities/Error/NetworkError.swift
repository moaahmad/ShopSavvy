//
//  NetworkError.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Foundation

enum NetworkError: LocalizedError {
    case connectivity
    case invalidResponse
    case invalidData

    var errorDescription: String? {
        switch self {
        case .connectivity:
            return "generic_error_title".localized()
        case .invalidData:
            return "invalid_data_error_title".localized()
        case .invalidResponse:
            return "invalid_response_error_title".localized()
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .connectivity:
            return "connectivity_error_message".localized()
        case .invalidData:
            return "generic_error_message".localized()
        case .invalidResponse:
            return "generic_error_message".localized()
        }
    }
}
