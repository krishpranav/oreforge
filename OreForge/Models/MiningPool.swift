//
//  MiningPool.swift
//  OreForge
//
//  Created by Krisna Pranav on 28/10/25.
//

import Foundation

struct MiningPool: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var address: String
    var port: Int
    var protocol_: String
    var username: String
    var password: String
    var isActive: Bool
    var difficulty: Double
    var minimumPayout: Double
    var fee: Double

    init(id: UUID, name: String, address: String, port: Int, protocol_: String, username: String, password: String, isActive: Bool, difficulty: Double, minimumPayout: Double, fee: Double) {
        self.id = id
        self.name = name
        self.address = address
        self.port = port
        self.protocol_ = protocol_
        self.username = username
        self.password = password
        self.isActive = isActive
        self.difficulty = difficulty
        self.minimumPayout = 0.01
        self.fee = 1.0
    }

    var connectionString: String {
        "\(protocol_)://\(address):\(port)"
    }

    static func == (lhs: MiningPool, rhs: MiningPool) -> Bool {
        lhs.id == rhs.id
    }
}
