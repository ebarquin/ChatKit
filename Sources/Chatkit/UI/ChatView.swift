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
