//
//  MiningControlView.swift
//  OreForge
//
//  Created by Krisna Pranav on 29/10/25.
//

import Foundation
import SwiftUI

struct MiningControlView: View {
    @ObservedObject var miningService: MiningService
    @ObservedObject var configService: ConfigurationService
    @State private var selectedPool: MiningPool?
    @State private var selectedWorker: Worker?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Button(action: {
                        if miningService.isRunning {
                            miningService.stopMining()
                        } else if let pool = selectedPool, let worker = selectedWorker {
                            miningService.startMining(pool: pool, worker: worker)
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: miningService.isRunning ? "stop.circle.fill" : "play.circle.fill")
                                .font(.system(size: 20))
                            Text(miningService.isRunning ? "STOP MINING" : "START MINING")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundStyle(.white)
                        .background(
                            miningService.isRunning ?
                            Color.red.opacity(0.3) : Color.green.opacity(0.3)
                        )
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    .disabled(selectedPool == nil || selectedWorker == nil)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Mining Pool")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.8))

                        Menu {
                            ForEach(configService.savedPools) { pool in
                                Button(action: { selectedPool = pool }) {
                                    Text(pool.name)
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedPool?.name ?? "Choose a pool...")
                                    .foregroundStyle(selectedPool == nil ? .white.opacity(0.5) : .white)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(.white.opacity(0.6))
                            }
                            .padding(12)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(10)
                        }
                        .menuStyle(.automatic)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Worker")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.8))

                        Menu {
                            ForEach(configService.savedWorkers) { worker in
                                Button(action: { selectedWorker = worker }) {
                                    Text(worker.name)
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedWorker?.name ?? "Choose a worker...")
                                    .foregroundStyle(selectedWorker == nil ? .white.opacity(0.5) : .white)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(.white.opacity(0.6))
                            }
                            .padding(12)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(10)
                        }
                        .menuStyle(.automatic)
                    }
                }
                .padding(20)
                .glassCard()
                .padding(.horizontal, 20)

                if let session = miningService.currentSession {
                    VStack(spacing: 16) {
                        InfoRow(label: "Status", value: session.status.rawValue)
                        InfoRow(label: "Elapsed Time", value: Formatters.formatElapsedTime(session.elapsedTime))
                        InfoRow(label: "Shares", value: Formatters.formatShares(session.totalSharesAccepted, rejected: session.totalSharesRejected))
                        InfoRow(label: "Acceptance Rate", value: Formatters.formatPercentage(session.acceptanceRate))
                    }
                    .padding(20)
                    .glassCard()
                    .padding(.horizontal, 20)
                }

                Spacer(minLength: 20)
            }
            .padding(.vertical, 20)
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.white.opacity(0.7))
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.cyan)
        }
    }
}

