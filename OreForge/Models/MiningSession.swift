//
//  MiningSession.swift
//  OreForge
//
//  Created by Krisna Pranav on 28/10/25.
//

import Foundation

struct MiningSession: Identifiable, Codable {
    let id: UUID
    var status: MiningStatus
    var startTime: Date?
    var endTime: Date?
    var totalHashesComputed: UInt64
    var totalSharesAccepted: UInt32
    var totalSharesRejected: UInt32
    var currentHashRate: Double
    var averageHashRate: Double
    var poolAddress: String
    var workerName: String

    init(poolAddress: String, workerName: String) {
        self.id = UUID()
        self.status = .stopped
        self.startTime = nil
        self.endTime = nil
        self.totalHashesComputed = 0
        self.totalSharesAccepted = 0
        self.totalSharesRejected = 0
        self.currentHashRate = 0.0
        self.averageHashRate = 0.0
        self.poolAddress = poolAddress
        self.workerName = workerName
    }

    var acceptanceRate: Double {
        guard totalSharesAccepted + totalSharesRejected > 0 else {
            return 0
        }

        return Double(totalSharesAccepted) / Double(totalSharesAccepted + totalSharesRejected) * 100
    }

    var elapsedTime: TimeInterval {
        guard let start = startTime else {
            return 0
        }

        let end = endTime ?? Date()

        return end.timeIntervalSince(start)
    }

    var isActive: Bool {
        status == .running
    }
}

enum MiningStatus: String, Codable, CaseIterable {
    case stopped = "Stopped"
    case running = "Running"
    case paused = "Paused"
    case error = "Error"
    case initializing = "Initializing"

    var color: String {
        switch self {
        case .running:
            return "systemGreen"
        case .paused:
            return "systemYellow"
        case .error:
            return "systemRed"
        case .initializing:
            return "systemBlue"
        case .stopped:
            return "systemGray"
        }
    }
}
