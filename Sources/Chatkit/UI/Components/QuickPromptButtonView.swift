import SwiftUI

struct QuickPromptButtonView: View {

    let prompt: QuickPrompt
    let appearance: ChatAppearance
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(prompt.title)
                .font(.callout)
                .lineLimit(1)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
        }
        .background(appearance.userBubble.background)
        .foregroundColor(appearance.userBubble.foreground)
        .clipShape(Capsule())
        .buttonStyle(.plain)
        .accessibilityLabel(prompt.title)
    }
}
