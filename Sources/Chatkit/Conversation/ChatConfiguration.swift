public struct ChatConfiguration {

    public let initialMessages: [ChatMessage]
    public let placeholder: String
    public let quickPrompts: [QuickPrompt]

    public init(
        initialMessages: [ChatMessage] = [],
        placeholder: String = "Type a message…",
        quickPrompts: [QuickPrompt] = []
    ) {
        self.initialMessages = initialMessages
        self.placeholder = placeholder
        self.quickPrompts = quickPrompts
    }

    public static let `default` = ChatConfiguration()
}
