//
//  AnimationHelpers.swift
//  OreForge
//
//  Created by Krisna Pranav on 29/10/25.
//

import Foundation
import SwiftUI

struct PulseAnimation: ViewModifier {
    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1.05 : 1.0)
            .opacity(isAnimating ? 1.0 : 0.8)
            .animation(
                Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

struct GlowEffect: ViewModifier {
    let color: Color
    let radius: CGFloat

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.7), radius: radius / 2)
            .shadow(color: color.opacity(0.4), radius: radius)
    }
}

extension View {
    func pulseAnimation() -> some View {
        modifier(PulseAnimation())
    }

    func glowEffect(_ color: Color = .blue, radius: CGFloat = 10) -> some View {
        modifier(GlowEffect(color: color, radius: radius))
    }
}
