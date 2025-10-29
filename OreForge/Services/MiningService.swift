//
//  MiningService.swift
//  OreForge
//
//  Created by Krisna Pranav on 29/10/25.
//

import Foundation
import Combine

@MainActor
class MiningService: NSObject, ObservableObject {
    @Published var currentSession: MiningSession?
    @Published var workers: [Worker] = []
    @Published var isRunning: Bool = false
    @Published var totalHashRate: Double = 0.0
    @Published var totalEarnings: Double = 0.0
    @Published var statistics: [Statistics] = []
    @Published var error: String?

    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private let poolService = PoolConnectionService()
    private let monitoringService = MonitoringService()
    private let configService = ConfigurationService()

    override init() {
        super.init()
        setupObservers()
    }

    private func setupObservers() {
        monitoringService.$systemStats
            .sink { [weak self] stats in
                Task { @MainActor in
                    self?.updateStatistics(stats)
                }
            }
            .store(in: &cancellables)
    }

    func startMining(pool: MiningPool, worker: Worker) {
        guard !isRunning else {
            error = "Mining already running"
            return
        }

        isRunning = true
        currentSession = MiningSession(poolAddress: pool.address, workerName: worker.name)
        currentSession?.status = .initializing
        currentSession?.startTime = Date()

        var updatedWorker = worker
        updatedWorker.isRunning = true
        workers.append(updatedWorker)

        monitoringService.startMonitoring()
        poolService.connect(to: pool)

        startHashRateSimulation()

        currentSession?.status = .running
    }

    func stopMining() {
        guard isRunning else { return }

        isRunning = false
        timer?.invalidate()
        poolService.disconnect()
        monitoringService.stopMonitoring()

        currentSession?.status = .stopped
        currentSession?.endTime = Date()

        workers = workers.map { var w = $0; w.isRunning = false; return w }
    }

    func pauseMining() {
        guard isRunning else { return }

        currentSession?.status = .paused
        timer?.invalidate()
    }

    func resumeMining() {
        guard currentSession?.status == .paused else { return }

        currentSession?.status = .running
        startHashRateSimulation()
    }

    private func startHashRateSimulation() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateHashRate()
            }
        }
    }

    private func updateHashRate() {
        let baseHashRate = Double.random(in: 95.0...105.0)
        totalHashRate = baseHashRate

        if var session = currentSession {
            session.currentHashRate = baseHashRate
            session.totalHashesComputed += UInt64(baseHashRate)

            if Bool.random(probability: 0.1) {
                session.totalSharesAccepted += 1
            }
            if Bool.random(probability: 0.02) {
                session.totalSharesRejected += 1
            }

            currentSession = session
        }

        workers = workers.enumerated().map { idx, worker in
            var w = worker
            w.currentHashRate = totalHashRate / Double(workers.count)
            w.totalHashes += UInt64(w.currentHashRate)
            w.lastUpdate = Date()
            if Bool.random(probability: 0.08) {
                w.sharesAccepted += 1
            }
            return w
        }
    }

    private func updateStatistics(_ sysStats: SystemStatistics) {
        var stat = Statistics()
        stat.hashRate = totalHashRate
        stat.cpuUsage = sysStats.cpuUsage
        stat.gpuUsage = sysStats.gpuUsage
        stat.temperature = sysStats.temperature
        stat.powerConsumption = sysStats.powerConsumption

        statistics.append(stat)
        if statistics.count > 1440 {
            statistics.removeFirst()
        }

        let hashRatePerHour = totalHashRate * 3600
        totalEarnings += (hashRatePerHour / 1_000_000) * 0.0001
    }

    func addWorker(_ worker: Worker) {
        var newWorker = worker
        newWorker.isRunning = isRunning
        workers.append(newWorker)
    }

    func removeWorker(_ worker: Worker) {
        workers.removeAll { $0.id == worker.id }
    }

    deinit {
        stopMining()
    }
}
