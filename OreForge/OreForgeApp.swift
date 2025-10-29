//
//  OreForgeApp.swift
//  OreForge
//
//  Created by Krisna Pranav on 28/10/25.
//

import SwiftUI

@main
struct OreForgeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1000, minHeight: 700)
                .preferredColorScheme(.dark)
        }
        .windowStyle(.hiddenTitleBar)
    }
}
