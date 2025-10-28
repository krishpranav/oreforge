//
//  Statistics.swift
//  OreForge
//
//  Created by Krisna Pranav on 28/10/25.
//

import Foundation

struct Statistics: Codable {
    var timestamp: Date
    var hashRate: Double
    var difficulty: Double
    var sharesAccepted: UInt32
    var sharesRejected: UInt32
    var earnings: Double
    var temperature: Double
    var cpuUsage: Double
    var gpuUsage: Double
    var powerConsumption: Double

    init(timestamp: Date = Date()) {
        self.timestamp = timestamp
        self.hashRate = 0.0
        self.difficulty = 0.0
        self.sharesAccepted = 0
        self.sharesRejected = 0
        self.earnings = 0.0
        self.temperature = 0.0
        self.cpuUsage = 0.0
        self.gpuUsage = 0.0
        self.powerConsumption = 0.0
    }
}

struct HistoricalData: Codable {
    var dataPoints: [Statistics] = []

    mutating func addDataPoint(_ stat: Statistics) {
        dataPoints.append(stat)

        if dataPoints.count > 1440 {
            dataPoints.removeFirst(dataPoints.count - 1440)
        }
    }

    var averageHashRate: Double {
        guard !dataPoints.isEmpty else { return 0 }
        return dataPoints.reduce(0) { $0 + $1.hashRate } / Double(dataPoints.count)
    }

    var peakHashRate: Double {
        dataPoints.map { $0.hashRate }.max() ?? 0
    }

    var averageTemperature: Double {
        guard !dataPoints.isEmpty else { return 0 }
        return dataPoints.reduce(0) { $0 + $1.temperature } / Double(dataPoints.count)
    }
}
