import SwiftUI

public struct MessageRowView: View {

    let message: ChatMessage
    let appearance: ChatAppearance
    let layout: ChatLayout
    let maxBubbleWidth: CGFloat

    public init(
        message: ChatMessage,
        appearance: ChatAppearance,
        layout: ChatLayout,
        maxBubbleWidth: CGFloat
    ) {
        self.message = message
        self.appearance = appearance
        self.layout = layout
        self.maxBubbleWidth = maxBubbleWidth
    }

    public var body: some View {
        switch message.role {
        case .system:
            systemMessage
        case .assistant:
            assistantRow
        case .user:
            userRow
        }
    }

    private var assistantRow: some View {
        HStack {
            bubble(style: appearance.assistantBubble, alignment: .leading)
            Spacer(minLength: layout.minSpacer)
        }
        .padding(.horizontal, layout.horizontalPadding)
        .padding(.vertical, layout.verticalPadding)
    }

    private var userRow: some View {
        HStack {
            Spacer(minLength: layout.minSpacer)
            bubble(style: appearance.userBubble, alignment: .trailing)
        }
        .padding(.horizontal, layout.horizontalPadding)
        .padding(.vertical, layout.verticalPadding)
    }

    private var systemMessage: some View {
        Text(message.content)
            .font(.footnote)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, layout.horizontalPadding)
            .padding(.vertical, layout.verticalPadding)
            .opacity(0.8)
    }

    @ViewBuilder
    private func bubble(style: BubbleStyle, alignment: Alignment) -> some View {
        Group {
            if message.status == .streaming {
                TypingIndicatorView()
            } else {
                Text(message.content)
                    .font(appearance.font)
                    .foregroundColor(style.foreground)
            }
        }
        .padding(appearance.contentPadding)
        .background(style.background)
        .cornerRadius(style.cornerRadius)
        .frame(maxWidth: maxBubbleWidth, alignment: alignment)
        .transition(.opacity)
    }
}

private struct TypingIndicatorView: View {
    @State private var opacity: Double = 0.3

    var body: some View {
        Text("•••")
            .font(.body)
            .foregroundColor(.secondary)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true)
                ) {
                    opacity = 1.0
                }
            }
    }
}
