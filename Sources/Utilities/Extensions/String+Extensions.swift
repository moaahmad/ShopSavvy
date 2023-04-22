//
//  String+Extensions.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 22/04/2023.
//

import Foundation

extension String {
    func localized(_ parameters: CVarArg...) -> String {
        var string = NSLocalizedString(self, comment: "")
        if string == self {
            string = NSLocalizedString(self, tableName: nil, bundle: .main, value: self, comment: "")
        }
        return String(format: string, arguments: parameters)
    }
}
