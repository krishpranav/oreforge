//
//  Constants.swift
//  OreForge
//
//  Created by Krisna Pranav on 29/10/25.
//

import Foundation

struct AppConstants {
    static let appName = "ORE FORGE"
    static let appVersion = "1.0.0"
    static let minWindowWidth: CGFloat = 1000
    static let minWindowHeight: CGFloat = 700

    struct Mining {
        static let defaultHashRate: Double = 100.0
        static let maxTemperature: Double = 95.0
        static let warningTemperature: Double = 80.0
        static let criticalTemperature: Double = 85.0
    }

    struct UI {
        static let cornerRadius: CGFloat = 16
        static let smallCornerRadius: CGFloat = 8
        static let standardSpacing: CGFloat = 16
        static let smallSpacing: CGFloat = 8
        static let glassOpacity: Double = 0.1
    }

    struct Animation {
        static let standardDuration: Double = 0.3
        static let longDuration: Double = 1.5
        static let pulseDuration: Double = 1.5
    }
}
