//
//  MonitoringService.swift
//  OreForge
//
//  Created by Krisna Pranav on 29/10/25.
//

import Foundation

struct SystemStatistics: Codable {
    var cpuUsage: Double = 0.0
    var gpuUsage: Double = 0.0
    var temperature: Double = 0.0
    var powerConsumption: Double = 0.0
    var ramUsage: Double = 0.0
}

@MainActor
class MonitoringService: NSObject, ObservableObject {
    @Published var systemStats = SystemStatistics()

    private var monitoringTimer: Timer?

    func startMonitoring() {
        monitoringTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateSystemStats()
            }
        }
    }

    func stopMonitoring() {
        monitoringTimer?.invalidate()
        monitoringTimer = nil
    }

    private func updateSystemStats() {
        systemStats.cpuUsage = Double.random(in: 20.0...80.0)
        systemStats.gpuUsage = Double.random(in: 40.0...95.0)
        systemStats.temperature = Double.random(in: 45.0...75.0)
        systemStats.powerConsumption = (systemStats.cpuUsage + systemStats.gpuUsage) / 2 * 2.5
        systemStats.ramUsage = Double.random(in: 10.0...40.0)
    }
}
