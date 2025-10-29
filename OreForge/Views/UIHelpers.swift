//
//  UIHelpers.swift
//  OreForge
//
//  Created by Krisna Pranav on 29/10/25.
//

import Foundation
import SwiftUI

struct AnimatedGradientBackground: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            // Dark base
            Color(red: 0.05, green: 0.05, blue: 0.1)

            // Animated gradient overlays
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.2, blue: 0.4).opacity(0.3),
                    Color(red: 0.05, green: 0.1, blue: 0.2).opacity(0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Animated mesh gradient effect - First circle
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.2, green: 0.8, blue: 1.0).opacity(0.1),
                            Color.clear
                        ]),
                        center: UnitPoint(x: 0.2, y: 0.2),
                        startRadius: 0,
                        endRadius: 500
                    )
                )
                .offset(x: animate ? 100 : -100, y: animate ? -100 : 100)
                .animation(
                    Animation.easeInOut(duration: 8)
                        .repeatForever(autoreverses: true),
                    value: animate
                )

            // Animated mesh gradient effect - Second circle
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.5, green: 0.6, blue: 1.0).opacity(0.1),
                            Color.clear
                        ]),
                        center: UnitPoint(x: 0.8, y: 0.8),
                        startRadius: 0,
                        endRadius: 600
                    )
                )
                .offset(x: animate ? -150 : 150, y: animate ? 100 : -100)
                .animation(
                    Animation.easeInOut(duration: 10)
                        .repeatForever(autoreverses: true),
                    value: animate
                )
        }
        .onAppear {
            animate = true
        }
    }
}
