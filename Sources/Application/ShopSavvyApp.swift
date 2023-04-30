//
//  ShopSavvyApp.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 12/04/2023.
//

import SwiftUI

struct ShopSavvyApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
            #if DEBUG
                .onAppear {
                    guard CommandLine.arguments.contains("–uitesting") else { return }
                    UITestingNetworkHandler.register()
                }
            #endif
        }
    }
}
