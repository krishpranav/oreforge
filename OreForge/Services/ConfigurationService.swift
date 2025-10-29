//
//  ConfigurationService.swift
//  OreForge
//
//  Created by Krisna Pranav on 29/10/25.
//

import Foundation

class ConfigurationService: ObservableObject {
    @Published var savedPools: [MiningPool] = []
    @Published var savedWorkers: [Worker] = []
    @Published var userPreferences: UserPreferences = UserPreferences()

    private let poolsKey = "savedPools"
    private let workersKey = "savedWorkers"
    private let preferencesKey = "userPreferences"

    init() {
        loadConfiguration()
        setupDefaultData()
    }

    private func loadConfiguration() {
        if let poolsData = UserDefaults.standard.data(forKey: poolsKey),
           let pools = try? JSONDecoder().decode([MiningPool].self, from: poolsData) {
            savedPools = pools
        }

        if let workersData = UserDefaults.standard.data(forKey: workersKey),
           let workers = try? JSONDecoder().decode([Worker].self, from: workersData) {
            savedWorkers = workers
        }

        if let prefsData = UserDefaults.standard.data(forKey: preferencesKey),
           let prefs = try? JSONDecoder().decode(UserPreferences.self, from: prefsData) {
            userPreferences = prefs
        }
    }

    private func setupDefaultData() {
        if savedPools.isEmpty {
            savedPools = [
                MiningPool(name: "Ethermine", address: "pool.ethermine.org", port: 4444),
                MiningPool(name: "F2Pool", address: "stratum.f2pool.com", port: 8008),
                MiningPool(name: "SparkPool", address: "cn.sparkpool.com", port: 3333)
            ]
        }

        if savedWorkers.isEmpty {
            savedWorkers = [
                Worker(name: "GPU-1", type: .gpu),
                Worker(name: "CPU-1", type: .cpu)
            ]
        }
    }

    func savePool(_ pool: MiningPool) {
        if !savedPools.contains(where: { $0.id == pool.id }) {
            savedPools.append(pool)
        }
        persistPools()
    }

    func removePool(_ pool: MiningPool) {
        savedPools.removeAll { $0.id == pool.id }
        persistPools()
    }

    private func persistPools() {
        if let encoded = try? JSONEncoder().encode(savedPools) {
            UserDefaults.standard.set(encoded, forKey: poolsKey)
        }
    }

    func saveWorker(_ worker: Worker) {
        if !savedWorkers.contains(where: { $0.id == worker.id }) {
            savedWorkers.append(worker)
        }
        persistWorkers()
    }

    func removeWorker(_ worker: Worker) {
        savedWorkers.removeAll { $0.id == worker.id }
        persistWorkers()
    }

    private func persistWorkers() {
        if let encoded = try? JSONEncoder().encode(savedWorkers) {
            UserDefaults.standard.set(encoded, forKey: workersKey)
        }
    }
}

struct UserPreferences: Codable {
    var autoStartMining: Bool = false
    var displayCurrency: String = "USD"
    var refreshInterval: Double = 1.0
    var maxTemperature: Double = 85.0
    var enableNotifications: Bool = true
    var darkMode: Bool = true
}
