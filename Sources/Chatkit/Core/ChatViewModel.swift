import Foundation
import Combine

@MainActor
public final class ChatViewModel: ObservableObject {

    // MARK: - Published state

    @Published public private(set) var messages: [ChatMessage]
    @Published public private(set) var phase: ChatPhase = .ready

    // MARK: - Configuration

    public let quickPrompts: [QuickPrompt]

    // MARK: - Callbacks (owned by consumer)

    public var onSend: (ChatMessage) -> Void

    // MARK: - Init

    public init(
        initialMessages: [ChatMessage] = [],
        quickPrompts: [QuickPrompt] = [],
        onSend: @escaping (ChatMessage) -> Void
    ) {
        self.messages = initialMessages
        self.quickPrompts = quickPrompts
        self.onSend = onSend
    }

    // MARK: - Public API

    public func sendUserText(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let message = ChatMessage(
            role: .user,
            content: trimmed,
            status: .completed
        )

        messages.append(message)
        phase = .awaitingAssistant
        onSend(message)
    }

    public func send(prompt: QuickPrompt) {
        sendUserText(prompt.message)
    }

    /// Consumer injects messages (assistant, system, user… we don't care)
    public func appendMessage(_ message: ChatMessage) {
        messages.append(message)

        if message.role == .assistant {
            phase = .ready
        }
    }

    public func appendMessages(_ newMessages: [ChatMessage]) {
        messages.append(contentsOf: newMessages)

        if newMessages.contains(where: { $0.role == .assistant }) {
            phase = .ready
        }
    }

    public func setAwaitingAssistant() {
        phase = .awaitingAssistant
    }

    public func setError(_ description: String) {
        phase = .error(description)
    }

    public func resetError() {
        if case .error = phase {
            phase = .ready
        }
    }
}
