//
//  Worker.swift
//  OreForge
//
//  Created by Krisna Pranav on 28/10/25.
//

import Foundation


struct Worker: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: WorkerType
    var isRunning: Bool
    var currentHashRate: Double
    var totalHashes: UInt64
    var sharesAccepted: UInt32
    var sharesRejected: UInt32
    var temperature: Double
    var powerUsage: Double
    var gpuLoad: Double
    var cpuLoad: Double
    var lastUpdate: Date

    init(name: String, type: WorkerType) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.isRunning = false
        self.currentHashRate = 0.0
        self.totalHashes = 0
        self.sharesAccepted = 0
        self.sharesRejected = 0
        self.temperature = 0.0
        self.powerUsage = 0.0
        self.gpuLoad = 0.0
        self.cpuLoad = 0.0
        self.lastUpdate = Date()
    }

    var shareAcceptanceRate: Double {
        let total = sharesAccepted + sharesRejected
        guard total > 0 else {
            return 0
        }

        return Double(sharesAccepted) / Double(total) * 100
    }

    var statusIndicator: String {
        switch (isRunning, temperature) {
        case (true, let temp) where temp > 85:
            return "🔴"
        case (true, let temp) where temp > 70:
            return "🟠"
        case (true, _):
            return "🟢"
        case (false, _):
            return "⚫"
        }
    }
}

enum WorkerType: String, Codable, CaseIterable {
    case cpu = "CPU"
    case gpu = "GPU"
    case hybrid = "Hybrid"

    var systemImage: String {
        switch self {
        case .cpu:
            return "cpu"
        case .gpu:
            return "square.stack.3d.up"
        case .hybrid:
            return "square.stack.3d.up.badge.checkmark"
        }
    }
}
