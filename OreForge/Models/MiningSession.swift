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
        }
    }
}
