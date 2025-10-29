//
//  ValidationHelper.swift
//  OreForge
//
//  Created by Krisna Pranav on 29/10/25.
//

import Foundation

struct ValidationHelper {
    static func isValidPoolAddress(_ address: String) -> Bool {
        let trimmed = address.trimmingCharacters(in: .whitespaces)
        return !trimmed.isEmpty && trimmed.count > 3
    }

    static func isValidPort(_ port: String) -> Bool {
        guard let portInt = Int(port) else { return false }
        return portInt > 0 && portInt < 65536
    }

    static func isValidWorkerName(_ name: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        return !trimmed.isEmpty && trimmed.count > 0 && trimmed.count < 100
    }

    static func isValidPoolName(_ name: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        return !trimmed.isEmpty && trimmed.count > 0 && trimmed.count < 100
    }

    static func isValidTemperatureThreshold(_ temp: Double) -> Bool {
        return temp >= 60 && temp <= 95
    }
}
