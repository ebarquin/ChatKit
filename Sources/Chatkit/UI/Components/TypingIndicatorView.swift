import SwiftUI

/// Animated typing indicator (three dots with fading opacity).
struct TypingIndicatorView: View {

    @State private var phase: Int = 0

    private let dotCount = 3
    private let animationDuration: Double = 0.6

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<dotCount, id: \.self) { index in
                Circle()
                    .frame(width: 6, height: 6)
                    .opacity(phase == index ? 1.0 : 0.3)
            }
        }
        .animation(
            .easeInOut(duration: animationDuration)
                .repeatForever(autoreverses: true),
            value: phase
        )
        .onAppear {
            startAnimation()
        }
    }

    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: animationDuration / 2, repeats: true) { _ in
            phase = (phase + 1) % dotCount
        }
    }
}
