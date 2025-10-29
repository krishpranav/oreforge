//
//  SettingsView.swift
//  OreForge
//
//  Created by Krisna Pranav on 29/10/25.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @ObservedObject var configService: ConfigurationService
    @State private var showPoolForm = false
    @State private var showWorkerForm = false
    @State private var newPoolName = ""
    @State private var newPoolAddress = ""
    @State private var newPoolPort = "4444"
    @State private var newWorkerName = ""
    @State private var selectedWorkerType: WorkerType = .gpu

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Preferences")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)

                    HStack {
                        Label("Auto-start Mining", systemImage: "power.circle.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.white)
                        Spacer()
                        Toggle("", isOn: $configService.userPreferences.autoStartMining)
                    }

                    HStack {
                        Label("Notifications", systemImage: "bell.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.white)
                        Spacer()
                        Toggle("", isOn: $configService.userPreferences.enableNotifications)
                    }

                    Divider()
                        .background(Color.white.opacity(0.1))

                    VStack(alignment: .leading, spacing: 8) {
                        Label("Max Temperature", systemImage: "thermometer.sun.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.white)
                        HStack {
                            Text("\(Int(configService.userPreferences.maxTemperature))°C")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.cyan)
                            Slider(value: $configService.userPreferences.maxTemperature, in: 60...95, step: 1)
                        }
                    }
                }
                .padding(16)
                .glassCard()
                .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Mining Pools")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                        Spacer()
                        Button(action: { showPoolForm = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(.cyan)
                        }
                        .buttonStyle(.plain)
                    }

                    ForEach(configService.savedPools) { pool in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(pool.name)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(.white)
                                Text("\(pool.address):\(pool.port)")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.white.opacity(0.6))
                            }
                            Spacer()
                            Button(action: { configService.removePool(pool) }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.red.opacity(0.6))
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(12)
                        .background(Color.white.opacity(0.03))
                        .cornerRadius(8)
                    }
                }
                .padding(16)
                .glassCard()
                .padding(.horizontal, 20)

                // Workers management
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Workers")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                        Spacer()
                        Button(action: { showWorkerForm = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(.cyan)
                        }
                        .buttonStyle(.plain)
                    }

                    ForEach(configService.savedWorkers) { worker in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(worker.name)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(.white)
                                Label(worker.type.rawValue, systemImage: worker.type.systemImage)
                                    .font(.system(size: 10))
                                    .foregroundStyle(.white.opacity(0.6))
                            }
                            Spacer()
                            Button(action: { configService.removeWorker(worker) }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.red.opacity(0.6))
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(12)
                        .background(Color.white.opacity(0.03))
                        .cornerRadius(8)
                    }
                }
                .padding(16)
                .glassCard()
                .padding(.horizontal, 20)

                Spacer(minLength: 20)
            }
            .padding(.vertical, 20)
        }
        .sheet(isPresented: $showPoolForm) {
            PoolFormView(isPresented: $showPoolForm, configService: configService)
        }
        .sheet(isPresented: $showWorkerForm) {
            WorkerFormView(isPresented: $showWorkerForm, configService: configService)
        }
    }
}

struct PoolFormView: View {
    @Binding var isPresented: Bool
    @ObservedObject var configService: ConfigurationService
    @State private var poolName = ""
    @State private var poolAddress = ""
    @State private var poolPort = "4444"

    var body: some View {
        VStack(spacing: 16) {
            Text("Add Mining Pool")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Pool Name")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.8))
                    TextField("e.g., Ethermine", text: $poolName)
                        .textFieldStyle(.roundedBorder)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Pool Address")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.8))
                    TextField("e.g., pool.example.com", text: $poolAddress)
                        .textFieldStyle(.roundedBorder)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Port")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.8))
                    TextField("e.g., 4444", text: $poolPort)
                        .textFieldStyle(.roundedBorder)
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.05))
            .cornerRadius(10)

            HStack(spacing: 12) {
                Button("Cancel") {
                    isPresented = false
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(8)

                Button("Add Pool") {
                    if !poolName.isEmpty && !poolAddress.isEmpty {
                        let port = Int(poolPort) ?? 4444
                        let pool = MiningPool(name: poolName, address: poolAddress, port: port)
                        configService.savePool(pool)
                        isPresented = false
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.cyan.opacity(0.3))
                .cornerRadius(8)
                .disabled(poolName.isEmpty || poolAddress.isEmpty)
            }

            Spacer()
        }
        .padding(24)
        .background(Color.black.opacity(0.8))
        .frame(minWidth: 400, minHeight: 300)
    }
}

struct WorkerFormView: View {
    @Binding var isPresented: Bool
    @ObservedObject var configService: ConfigurationService
    @State private var workerName = ""
    @State private var selectedType: WorkerType = .gpu

    var body: some View {
        VStack(spacing: 16) {
            Text("Add Worker")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Worker Name")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.8))
                    TextField("e.g., GPU-1", text: $workerName)
                        .textFieldStyle(.roundedBorder)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Worker Type")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.8))
                    Picker("Type", selection: $selectedType) {
                        ForEach(WorkerType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.05))
            .cornerRadius(10)

            HStack(spacing: 12) {
                Button("Cancel") {
                    isPresented = false
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(8)

                Button("Add Worker") {
                    if !workerName.isEmpty {
                        let worker = Worker(name: workerName, type: selectedType)
                        configService.saveWorker(worker)
                        isPresented = false
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.cyan.opacity(0.3))
                .cornerRadius(8)
                .disabled(workerName.isEmpty)
            }

            Spacer()
        }
        .padding(24)
        .background(Color.black.opacity(0.8))
        .frame(minWidth: 400, minHeight: 300)
    }
}
