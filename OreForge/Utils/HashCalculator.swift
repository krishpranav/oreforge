//
//  HashCalculator.swift
//  OreForge
//
//  Created by Krisna Pranav on 29/10/25.
//

import Foundation
import CryptoKit

struct HashCalculator {
    static func calculateSHA256(_ data: String) -> String {
        let digest = SHA256.hash(data: data.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }

    static func calculateDifficulty(_ hashRate: Double) -> Double {
        let baseTarget: Double = 0xFFFF
        let currentHash = hashRate * Double.random(in: 0.5...1.5)
        return baseTarget / currentHash
    }

    static func validateHash(_ hash: String, targetDifficulty: Double) -> Bool {
        guard let firstBytes = UInt64(hash.prefix(16), radix: 16) else {
            return false
        }
        let hashDifficulty = Double(UInt64.max) / Double(firstBytes)
        return hashDifficulty >= targetDifficulty
    }

    static func generateWorkPacket(poolAddress: String, workerName: String) -> [UInt8] {
        let data = "\(poolAddress):\(workerName)".data(using: .utf8) ?? Data()
        let digest = SHA256.hash(data: data)
        return Array(digest)
    }
}
