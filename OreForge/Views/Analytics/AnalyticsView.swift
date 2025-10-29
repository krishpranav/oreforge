//
//  AnalyticsView.swift
//  OreForge
//
//  Created by Krisna Pranav on 29/10/25.
//

import Foundation
import SwiftUI

struct AnalyticsView: View {
    @ObservedObject var miningService: MiningService

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if miningService.statistics.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 48))
                            .foregroundStyle(.white.opacity(0.3))
                        Text("No Data Available")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.7))
                        Text("Start mining to see analytics")
                            .font(.system(size: 12))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 60)
                } else {
                    VStack(spacing: 16) {
                        AnalyticsCard(
                            title: "Average Hash Rate",
                            value: Formatters.formatHashRate(miningService.statistics.map { $0.hashRate }.reduce(0, +) / Double(miningService.statistics.count)),
                            icon: "bolt.fill"
                        )

                        AnalyticsCard(
                            title: "Peak Hash Rate",
                            value: Formatters.formatHashRate(miningService.statistics.map { $0.hashRate }.max() ?? 0),
                            icon: "chart.line.uptrend.xyaxis"
                        )

                        AnalyticsCard(
                            title: "Average Temperature",
                            value: Formatters.formatTemperature(miningService.statistics.map { $0.temperature }.reduce(0, +) / Double(miningService.statistics.count)),
                            icon: "thermometer.sun.fill"
                        )

                        AnalyticsCard(
                            title: "Average Power",
                            value: Formatters.formatPower((miningService.statistics.map { $0.powerConsumption }.reduce(0, +) / Double(miningService.statistics.count)) * 100),
                            icon: "bolt.circle.fill"
                        )
                    }
                    .padding(20)
                }

                Spacer(minLength: 20)
            }
            .padding(.vertical, 20)
        }
    }
}

struct AnalyticsCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.cyan)
                Text(title)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
            }

            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(16)
        .glassCard()
    }
}
