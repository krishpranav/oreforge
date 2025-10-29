//
//  Formatters.swift
//  OreForge
//
//  Created by Krisna Pranav on 29/10/25.
//

import Foundation

struct Formatters {
    static func formatHashRate(_ hashRate: Double) -> String {
        let units = ["H/s", "KH/s", "MH/s", "GH/s", "TH/s", "PH/s"]
        var rate = hashRate
        var unitIndex = 0

        while rate >= 1000 && unitIndex < units.count - 1 {
            rate /= 1000
            unitIndex += 1
        }

        return String(format: "%.2f %@", rate, units[unitIndex])
    }

    static func formatCurrency(_ amount: Double, currency: String = "USD") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 8
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }

    static func formatTemperature(_ celsius: Double) -> String {
        return String(format: "%.1f°C", celsius)
    }

    static func formatPercentage(_ value: Double) -> String {
        return String(format: "%.1f%%", value)
    }

    static func formatElapsedTime(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 2
        return formatter.string(from: interval) ?? "0s"
    }

    static func formatShares(_ accepted: UInt32, rejected: UInt32) -> String {
        return "\(accepted)↑ / \(rejected)↓"
    }

    static func formatBytes(_ bytes: UInt64) -> String {
        let units = ["B", "KB", "MB", "GB", "TB"]
        var size = Double(bytes)
        var unitIndex = 0

        while size >= 1024 && unitIndex < units.count - 1 {
            size /= 1024
            unitIndex += 1
        }

        return String(format: "%.2f %@", size, units[unitIndex])
    }

    static func formatPower(_ watts: Double) -> String {
        if watts >= 1000 {
            return String(format: "%.2f kW", watts / 1000)
        }
        return String(format: "%.0f W", watts)
    }
}
