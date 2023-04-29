//
//  AppLauncher.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 28/04/2023.
//

import SwiftUI

@main
struct AppLauncher {
    static func main() throws {
        if isRunningTests {
            TestApp.main()
        } else {
            ShopSavvyApp.main()
        }
    }
}

extension AppLauncher: TestRunnable {}
