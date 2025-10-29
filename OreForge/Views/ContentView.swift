//
//  ContentView.swift
//  OreForge
//
//  Created by Krisna Pranav on 28/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var miningService = MiningService()
    @StateObject private var configService = ConfigurationService()
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack {
            AnimatedGradientBackground()
                .ignoresSafeArea()

            VStack(spacing: 0) {

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("ORE FORGE")
                            .font(.system(size: 28, weight: .bold, design: .default))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.2, green: 0.8, blue: 1.0),
                                        Color(red: 0.5, green: 0.6, blue: 1.0)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        Text("Professional Mining Dashboard")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    Spacer()

                    VStack(spacing: 6) {
                        Circle()
                            .fill(miningService.isRunning ? Color.green : Color.gray)
                            .frame(width: 12, height: 12)
                            .pulseAnimation()
                        Text(miningService.isRunning ? "MINING" : "IDLE")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
                .padding(20)

                Divider()
                    .background(Color.white.opacity(0.1))

                ZStack {
                    switch selectedTab {
                    case 0:
                        DashboardView(miningService: miningService, configService: configService)
                    case 1:
                        MiningControlView(miningService: miningService, configService: configService)
                    case 2:
                        AnalyticsView(miningService: miningService)
                    case 3:
                        SettingsView(configService: configService)
                    default:
                        DashboardView(miningService: miningService, configService: configService)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Divider()
                    .background(Color.white.opacity(0.1))

                HStack(spacing: 0) {
                    TabBarItem(
                        icon: "chart.pie.fill",
                        label: "Dashboard",
                        isSelected: selectedTab == 0,
                        action: { selectedTab = 0 }
                    )
                    TabBarItem(
                        icon: "play.circle.fill",
                        label: "Mining",
                        isSelected: selectedTab == 1,
                        action: { selectedTab = 1 }
                    )
                    TabBarItem(
                        icon: "chart.line.uptrend.xyaxis",
                        label: "Analytics",
                        isSelected: selectedTab == 2,
                        action: { selectedTab = 2 }
                    )
                    TabBarItem(
                        icon: "gearshape.fill",
                        label: "Settings",
                        isSelected: selectedTab == 3,
                        action: { selectedTab = 3 }
                    )
                }
                .background(Color.black.opacity(0.3))
                .padding(.horizontal, 1)
            }
        }
        .frame(minWidth: 1000, minHeight: 700)
    }
}

struct TabBarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                Text(label)
                    .font(.system(size: 11, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .foregroundStyle(isSelected ? .cyan : .white.opacity(0.5))
            .background(
                isSelected ? Color.cyan.opacity(0.1) : Color.clear
            )
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    ContentView()
}
