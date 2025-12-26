import SwiftUI
import ChatKit

struct ContentView: View {

    @StateObject private var viewModel: ChatViewModel
    private let brandAppearance: ChatAppearancePair

    init() {
        var vmRef: ChatViewModel?

        let vm = ChatViewModel(
            initialMessages: [
                ChatMessage(
                    role: .assistant,
                    content: "Hi! Ask me anything.",
                    status: .completed
                )
            ],
            quickPrompts: [
                QuickPrompt(id: UUID(), title: "Resume this", message: "Resume this"),
                QuickPrompt(id: UUID(), title: "Give examples", message: "Give examples"),
                QuickPrompt(id: UUID(), title: "Explain like I'm 5", message: "Explain like I'm 5")
            ],
            onSend: { message in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    let response = ChatMessage(
                        role: .assistant,
                        content: "Fake LLM response to: \(message.content)",
                        status: .completed
                    )
                    vmRef?.appendMessage(response)
                }
            }
        )
        
        vmRef = vm

        let lightAppearance = ChatAppearance(
            background: Color(.systemGroupedBackground),
            font: .callout,
            contentPadding: 14,
            userBubbleBackground: Color(red: 255/255, green: 204/255, blue: 0/255).opacity(0.25), // Vueling yellow
            assistantBubbleBackground: Color.gray.opacity(0.12),
            userForeground: .black,
            assistantForeground: .primary,
            cornerRadius: 18
        )

        let darkAppearance = ChatAppearance(
            background: Color(.black),
            font: .callout,
            contentPadding: 14,
            userBubbleBackground: Color(red: 255/255, green: 204/255, blue: 0/255).opacity(0.35),
            assistantBubbleBackground: Color.white.opacity(0.12),
            userForeground: .black,
            assistantForeground: .white,
            cornerRadius: 18
        )

        brandAppearance = ChatAppearancePair(
            light: lightAppearance,
            dark: darkAppearance
        )

        _viewModel = StateObject(wrappedValue: vm)
    }

    var body: some View {
        ChatView(
            viewModel: viewModel,
            appearance: brandAppearance,
            layout: .compact,
            behavior: .default
        )
    }
}
