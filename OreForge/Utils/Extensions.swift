//
//  Extensions.swift
//  OreForge
//
//  Created by Krisna Pranav on 29/10/25.
//
import SwiftUI
import Foundation

extension Double {
    func randomBool(probability: Double) -> Bool {
        return Double.random(in: 0.0...1.0) < probability
    }
}

extension Color {
    static let accentGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.2, green: 0.8, blue: 1.0),
            Color(red: 0.3, green: 0.6, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let successGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.0, green: 0.8, blue: 0.4),
            Color(red: 0.2, green: 0.95, blue: 0.5)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let warningGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 1.0, green: 0.7, blue: 0.0),
            Color(red: 1.0, green: 0.5, blue: 0.2)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let errorGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 1.0, green: 0.3, blue: 0.3),
            Color(red: 0.9, green: 0.1, blue: 0.1)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension View {
    func glassCard() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.1))
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                    )
            )
            .backdrop()
    }

    func backdrop() -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.2),
                            Color.white.opacity(0.05)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
    }

    func shadowStyle() -> some View {
        self.shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 8)
    }
}
