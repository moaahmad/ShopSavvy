//
//  NetworkError.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import Foundation

public enum NetworkError: LocalizedError {
    case connectivity
    case invalidResponse
    case invalidData

    public var errorDescription: String? {
        switch self {
        case .connectivity:
            return "generic_error_title".localized()
        case .invalidData:
            return "invalid_data_error_title".localized()
        case .invalidResponse:
            return "invalid_response_error_title".localized()
        }
    }

    public var recoverySuggestion: String? {
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

private extension String {
    func localized(_ parameters: CVarArg...) -> String {
        var string = NSLocalizedString(self, comment: "")
        if string == self {
            string = NSLocalizedString(self, tableName: nil, bundle: Bundle.module, value: self, comment: "")
        }
        return String(format: string, arguments: parameters)
    }
}
