/// Visual phase used by ChatKit to reflect UI state.
///
/// `ChatPhase` is intentionally UI-focused and does NOT represent
/// networking, LLM execution, or message lifecycle guarantees.
///
/// Responsibilities:
/// - `.ready`: The chat is idle and ready for user input.
/// - `.awaitingAssistant`: The user has sent a message and the UI should
///   reflect a waiting state (e.g. disable input, show a loader).
/// - `.error(String)`: A visual error state decided by the consumer.
///
/// ChatKit does not assume that a response will arrive, nor does it
/// enforce alternation between user and assistant messages.
/// The consumer controls when messages are injected.
public enum ChatPhase: Sendable, Equatable {
    case ready
    case awaitingAssistant
    case error(String)
}
