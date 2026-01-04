import Foundation
import Combine

@MainActor
public final class ChatViewModel: ObservableObject {

    // MARK: - Published state

    @Published public private(set) var messages: [ChatMessage]
    @Published public private(set) var phase: ChatPhase = .ready

    // MARK: - Configuration

    public let quickPrompts: [QuickPrompt]
    public let awaitingMode: AwaitingMode

    // MARK: - Callbacks (owned by consumer)

    public let onSend: (ChatMessage) -> Void

    // MARK: - Private state

    private var pendingAssistantMessageID: UUID?

    // MARK: - Init

    public init(
        initialMessages: [ChatMessage] = [],
        quickPrompts: [QuickPrompt] = [],
        awaitingMode: AwaitingMode = .automatic,
        onSend: @escaping (ChatMessage) -> Void
    ) {
        self.messages = initialMessages
        self.quickPrompts = quickPrompts
        self.awaitingMode = awaitingMode
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

        if awaitingMode == .automatic {
            _ = beginAwaitingAssistant()
        }

        onSend(message)
    }

    public func send(prompt: QuickPrompt) {
        sendUserText(prompt.message)
    }

    /// Inserts a placeholder assistant message in `idle` state
    /// and marks the view model as awaiting a response.
    ///
    /// This is a convenience helper for request/response style integrations.
    /// ChatKit does not update this message automatically.
    @discardableResult
    public func beginAwaitingAssistant() -> UUID {
        let message = ChatMessage(
            role: .assistant,
            content: "",
            status: .idle
        )
        messages.append(message)
        pendingAssistantMessageID = message.id
        phase = .awaitingAssistant
        return message.id
    }

    /// Completes a previously inserted assistant placeholder message.
    public func completeAssistantMessage(
        id: UUID,
        content: String
    ) {
        guard let index = messages.firstIndex(where: { $0.id == id }) else { return }
        messages[index].content = content
        messages[index].status = .completed
        pendingAssistantMessageID = nil
        phase = .ready
    }

    /// Updates the content of an existing assistant message.
    /// This enables real or simulated streaming by progressively mutating the message content.
    public func updateAssistantMessage(
        id: UUID,
        content: String
    ) {
        guard let index = messages.firstIndex(where: { $0.id == id }) else { return }
        messages[index].status = .streaming
        messages[index].content = content
    }

    /// Consumer injects messages (assistant, system, user… we don't care)
    public func appendMessage(_ message: ChatMessage) {
        if message.role == .assistant,
           let pendingID = pendingAssistantMessageID,
           let index = messages.firstIndex(where: { $0.id == pendingID }) {
            messages[index].content = message.content
            messages[index].status = message.status
            pendingAssistantMessageID = nil
            phase = .ready
            return
        }

        messages.append(message)

        if awaitingMode == .automatic, message.role == .assistant {
            phase = .ready
        }
    }

    public func appendMessages(_ newMessages: [ChatMessage]) {
        messages.append(contentsOf: newMessages)
        if awaitingMode == .automatic, newMessages.contains(where: { $0.role == .assistant }) {
            phase = .ready
        }
    }

    public func startAwaitingAssistant() {
        phase = .awaitingAssistant
    }

    public func stopAwaitingAssistant() {
        phase = .ready
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
