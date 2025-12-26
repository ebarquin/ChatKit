import SwiftUI

public struct ComposerView: View {

    let placeholder: String
    let behavior: ChatBehavior
    let sendButtonColor: Color
    let onSend: (String) -> Void
    let onCancel: (() -> Void)?

    @State private var text: String = ""

    public init(
        placeholder: String = "Write a message…",
        behavior: ChatBehavior = .default,
        sendButtonColor: Color = .primary,
        onSend: @escaping (String) -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self.behavior = behavior
        self.sendButtonColor = sendButtonColor
        self.onSend = onSend
        self.onCancel = onCancel
    }

    public var body: some View {
        minimalComposer
    }
}

// MARK: - Variants

private extension ComposerView {

    var minimalComposer: some View {
        HStack(spacing: 8) {
            inputField

            sendButton
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}

// MARK: - Subviews

private extension ComposerView {

    var inputField: some View {
        TextField(placeholder, text: $text, axis: .vertical)
            .lineLimit(1...6)
            .textFieldStyle(.plain)
            .submitLabel(behavior.sendOnReturn ? .send : .return)
            .onSubmit {
                guard behavior.sendOnReturn else { return }
                sendIfPossible()
            }
    }

    var sendButton: some View {
        Button {
            sendIfPossible()
        } label: {
            Image(systemName: "arrow.up.circle.fill")
                .font(.system(size: 24))
                .foregroundStyle(sendButtonColor)
        }
        .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        .opacity(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.4 : 1.0)
    }
}

// MARK: - Actions

private extension ComposerView {

    func sendIfPossible() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        text = ""
        onSend(trimmed)
    }
}
