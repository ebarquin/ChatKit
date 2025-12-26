public struct ChatBehavior: Sendable {

    public var autoScroll: Bool
    public var sendOnReturn: Bool
    public var showsCancelButton: Bool

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
