//
//  MockServer.swift
//  Tests
//
//  Created by Mo Ahmad on 17/04/2023.
//

import Foundation

public enum jsonFile: String {
    case products = "Products"
    case badJSON = "BadJSON"
}

public final class MockServer {
    public static func loadLocalJSON(_ fileName: jsonFile) -> Data {
        guard let path = Bundle.module.url(
                forResource: fileName.rawValue,
                withExtension: "json"
            ),
              let data = try? Data(contentsOf: path)
        else {
            fatalError("Mock data was not present in bundle")
        }

        return data
    }
}
