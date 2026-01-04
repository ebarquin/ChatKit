public struct ChatBehavior: Sendable {

    /// Automatically scrolls the chat to the latest message
    /// when new messages are appended.
    public let autoScroll: Bool
    public let sendOnReturn: Bool
    public let showsCancelButton: Bool

    public init(
        autoScroll: Bool,
        sendOnReturn: Bool,
        showsCancelButton: Bool
    ) {
        self.autoScroll = autoScroll
        self.sendOnReturn = sendOnReturn
        self.showsCancelButton = showsCancelButton
    }
}

// MARK: - Presets

public extension ChatBehavior {

    static let `default` = ChatBehavior(
        autoScroll: true,
        sendOnReturn: false,
        showsCancelButton: true
    )
}
