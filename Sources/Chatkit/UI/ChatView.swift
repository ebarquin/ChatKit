import SwiftUI

/// SwiftUI chat renderer.
///
/// `ChatView` displays messages provided by `ChatViewModel` and exposes no LLM/network logic.
/// The consumer is responsible for handling `onSend` and injecting incoming messages back into the model.
public struct ChatView: View {

    @ObservedObject private var viewModel: ChatViewModel
    @Environment(\.colorScheme) private var colorScheme

    private let appearance: ChatAppearance
    private let appearancePair: ChatAppearancePair?
    private let layout: ChatLayout
    private let behavior: ChatBehavior
    private let configuration: ChatConfiguration

    public init(
        viewModel: ChatViewModel,
        appearance: ChatAppearance = .default,
        layout: ChatLayout = .default,
        behavior: ChatBehavior = .default,
        configuration: ChatConfiguration = .default
    ) {
        self.viewModel = viewModel
        self.appearance = appearance
        self.appearancePair = nil
        self.layout = layout
        self.behavior = behavior
        self.configuration = configuration
    }

    public init(
        viewModel: ChatViewModel,
        appearance: ChatAppearancePair,
        layout: ChatLayout = .default,
        behavior: ChatBehavior = .default,
        configuration: ChatConfiguration = .default
    ) {
        self.viewModel = viewModel
        self.appearance = appearance.light
        self.appearancePair = appearance
        self.layout = layout
        self.behavior = behavior
        self.configuration = configuration
    }

    public var body: some View {
        let resolvedAppearance = appearancePair?
            .resolved(for: colorScheme)
            ?? appearance

        VStack(spacing: 0) {
            MessageListView(
                messages: viewModel.messages,
                appearance: resolvedAppearance,
                layout: layout,
                behavior: behavior
            )
            // Make the message list take the available space so the composer stays pinned to the bottom.
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if case .awaitingAssistant = viewModel.phase {
                TypingBubbleRowView(
                    appearance: resolvedAppearance,
                    layout: layout
                )
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: viewModel.phase)
            }

            if !viewModel.quickPrompts.isEmpty {
                QuickPromptBarView(
                    prompts: viewModel.quickPrompts,
                    appearance: resolvedAppearance,
                    onSelect: viewModel.send(prompt:)
                )
                // Prevent the prompt bar from expanding vertically and stealing layout from the list.
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)
            }

            ComposerView(
                placeholder: configuration.placeholder,
                behavior: behavior,
                onSend: { text in
                    viewModel.sendUserText(text)
                },
                onCancel: nil
            )
        }
        .background(resolvedAppearance.background)
    }
}


private struct TypingBubbleRowView: View {
    let appearance: ChatAppearance
    let layout: ChatLayout

    var body: some View {
        GeometryReader { geo in
            let maxBubbleWidth = geo.size.width * layout.maxBubbleWidthRatio

            HStack {
                typingBubble(maxBubbleWidth: maxBubbleWidth)
                Spacer(minLength: layout.minSpacer)
            }
            .padding(.horizontal, layout.horizontalPadding)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        // Keep it from taking over vertical space.
        .frame(height: 48)
        .accessibilityLabel("Assistant is typing")
    }

    private func typingBubble(maxBubbleWidth: CGFloat) -> some View {
        TypingDotsView()
            .padding(appearance.contentPadding)
            .background(appearance.assistantBubble.background)
            .cornerRadius(appearance.assistantBubble.cornerRadius)
            .frame(maxWidth: maxBubbleWidth, alignment: .leading)
    }
}

private struct TypingDotsView: View {
    private let dotCount = 3
    private let interval: TimeInterval = 0.22

    var body: some View {
        TimelineView(.animation) { timeline in
            HStack(spacing: 6) {
                ForEach(0..<dotCount, id: \.self) { index in
                    Circle()
                        .frame(width: 6, height: 6)
                        .opacity(opacity(for: index, timelineDate: timeline.date))
                }
            }
        }
    }

    private func opacity(for index: Int, timelineDate: Date) -> Double {
        let time = timelineDate.timeIntervalSinceReferenceDate
        let phaseOffset = Double(index) * 0.35
        let wave = sin((time + phaseOffset) * 2 * .pi)

        // Map sin(-1...1) → opacity(0.25...0.9)
        return 0.25 + (wave + 1) * 0.325
    }
}
