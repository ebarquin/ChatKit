import SwiftUI

public struct MessageListLayout: Sendable {

    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat
    public let messageSpacing: CGFloat

    public init(
        horizontalPadding: CGFloat,
        verticalPadding: CGFloat,
        messageSpacing: CGFloat
    ) {
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.messageSpacing = messageSpacing
    }
}

// MARK: - Presets

public extension MessageListLayout {

    static let `default` = MessageListLayout(
        horizontalPadding: 16,
        verticalPadding: 12,
        messageSpacing: 12
    )

    static let compact = MessageListLayout(
        horizontalPadding: 12,
        verticalPadding: 8,
        messageSpacing: 8
    )
}
