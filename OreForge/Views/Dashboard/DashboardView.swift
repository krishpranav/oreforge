//
//  DashboardView.swift
//  OreForge
//
//  Created by Krisna Pranav on 29/10/25.
//

import Foundation
import SwiftUI

struct DashboardView: View {
    @ObservedObject var miningService: MiningService
    @ObservedObject var configService: ConfigurationService

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Main stats grid
                HStack(spacing: 16) {
                    StatCard(
                        icon: "bolt.fill",
                        title: "Hash Rate",
                        value: Formatters.formatHashRate(miningService.totalHashRate),
                        trend: "+12.5%",
                        gradient: Color.accentGradient
                    )

                    StatCard(
                        icon: "dollarsign.circle.fill",
                        title: "Total Earnings",
                        value: Formatters.formatCurrency(miningService.totalEarnings),
                        trend: "+$2.50",
                        gradient: Color.successGradient
                    )
                }

                HStack(spacing: 16) {
                    StatCard(
                        icon: "thermometer.sun.fill",
                        title: "Temperature",
                        value: miningService.statistics.last.map { Formatters.formatTemperature($0.temperature) } ?? "N/A",
                        trend: "Normal",
                        gradient: Color.warningGradient
                    )

                    StatCard(
                        icon: "bolt.circle.fill",
                        title: "Power Usage",
                        value: miningService.statistics.last.map { Formatters.formatPower($0.powerConsumption * 100) } ?? "N/A",
                        trend: "Stable",
                        gradient: LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.8, green: 0.2, blue: 0.8),
                                Color(red: 0.6, green: 0.2, blue: 1.0)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                }

                // Worker status
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label("Active Workers", systemImage: "cpu")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                        Spacer()
                        Text("\(miningService.workers.count)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.cyan)
                    }

                    if miningService.workers.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "cpu")
                                .font(.system(size: 32))
                                .foregroundStyle(.white.opacity(0.3))
                            Text("No workers active")
                                .font(.system(size: 12))
                                .foregroundStyle(.white.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                    } else {
                        ForEach(miningService.workers) { worker in
                            WorkerStatusRow(worker: worker)
                        }
                    }
                }
                .padding(16)
                .glassCard()
                .padding(.horizontal, 20)

                // Recent stats
                if !miningService.statistics.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Last 60 Seconds")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)

                        HStack(spacing: 12) {
                            StatBubble(
                                label: "Avg Hash",
                                value: Formatters.formatHashRate(
                                    miningService.statistics.suffix(60).map { $0.hashRate }.reduce(0, +) / Double(max(miningService.statistics.count, 1))
                                )
                            )

                            StatBubble(
                                label: "CPU Load",
                                value: Formatters.formatPercentage(
                                    miningService.statistics.last?.cpuUsage ?? 0
                                )
                            )

                            StatBubble(
                                label: "GPU Load",
                                value: Formatters.formatPercentage(
                                    miningService.statistics.last?.gpuUsage ?? 0
                                )
                            )
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 16)
                    .glassCard()
                    .padding(.horizontal, 20)
                }

                Spacer(minLength: 20)
            }
            .padding(.vertical, 20)
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let trend: String
    let gradient: LinearGradient

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)

                Spacer()

                Text(trend)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.green)
            }

            Text(title)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.white.opacity(0.7))

            Text(value)
                .font(.system(size: 22, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .foregroundStyle(.white)
        }
        .padding(16)
        .background(gradient.opacity(0.1))
        .glassCard()
        .shadowStyle()
    }
}

struct StatBubble: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 6) {
            Text(label)
                .font(.system(size: 10, weight: .regular))
                .foregroundStyle(.white.opacity(0.6))

            Text(value)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.cyan)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.cyan.opacity(0.05))
        .cornerRadius(12)
    }
}

struct WorkerStatusRow: View {
    let worker: Worker

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(worker.name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)

                HStack(spacing: 8) {
                    Label(worker.type.rawValue, systemImage: worker.type.systemImage)
                        .font(.system(size: 10))
                        .foregroundStyle(.white.opacity(0.6))
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(Formatters.formatHashRate(worker.currentHashRate))
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.cyan)

                Text(Formatters.formatTemperature(worker.temperature))
                    .font(.system(size: 10))
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.03))
        .cornerRadius(10)
    }
}
