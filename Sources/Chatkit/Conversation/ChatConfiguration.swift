public struct ChatConfiguration {

    public let initialMessages: [ChatMessage]
    public let placeholder: String
    public let quickPrompts: [QuickPrompt]

    public init(
        initialMessages: [ChatMessage] = [],
        placeholder: String = "Escribe un mensaje…",
        quickPrompts: [QuickPrompt] = [
            QuickPrompt(
                        title: "Resume this",
                        message: "Can you summarize the previous answer?"
                    ),
                    QuickPrompt(
                        title: "Give examples",
                        message: "Can you give concrete examples?"
                    ),
                    QuickPrompt(
                        title: "Explain like I'm 5",
                        message: "Explain this in simple terms."
                    )
        ]
    ) {
        self.initialMessages = initialMessages
        self.placeholder = placeholder
        self.quickPrompts = quickPrompts
    }

    public static let `default` = ChatConfiguration()
}
