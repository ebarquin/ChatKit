import Foundation

/// Role associated with a chat message.
///
/// ChatKit does not enforce alternation between roles.
/// Messages are rendered strictly in the order they are provided.
public enum ChatRole: Sendable, Equatable {
    case user
    case assistant
    case system
}

/// Rendering state of a chat message.
///
/// This is primarily used for UI purposes (e.g. streaming, error states)
/// and does not imply any networking or LLM behaviour.
public enum MessageStatus: Sendable, Equatable {
    case idle
    case streaming
    case completed
    case failed(String)
    case cancelled
}

///
/// A single chat item rendered by ChatKit.
///
/// `ChatMessage` is a pure data model. ChatKit does not mutate messages
/// except for rendering purposes, and it does not enforce any conversational rules.
///
/// If two assistant messages are appended consecutively, both will be rendered.
/// If a system message is injected mid‑conversation, it will appear in place.
///
/// The meaning of `status` is UI‑focused (e.g. streaming, error display).
public struct ChatMessage: Identifiable, Sendable, Equatable {
    public let id: UUID
    public let role: ChatRole
    public var content: String
    public var status: MessageStatus

    public init(
        id: UUID = UUID(),
        role: ChatRole,
        content: String = "",
        status: MessageStatus = .idle
    ) {
        self.id = id
        self.role = role
        self.content = content
        self.status = status
    }
}
