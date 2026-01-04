import SwiftUI

public struct ChatLayout: Sendable {

    public let messageSpacing: CGFloat
    public let maxBubbleWidthRatio: CGFloat  // 0.0 ... 1.0
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat
    public let minSpacer: CGFloat

    public init(
        messageSpacing: CGFloat = 12,
        maxBubbleWidthRatio: CGFloat = 0.78,
        horizontalPadding: CGFloat = 12,
        verticalPadding: CGFloat = 8,
        minSpacer: CGFloat = 40
    ) {
        self.messageSpacing = messageSpacing
        self.maxBubbleWidthRatio = maxBubbleWidthRatio
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.minSpacer = minSpacer
    }
}

// MARK: - Presets

public extension ChatLayout {

    static let `default` = ChatLayout(
        messageSpacing: 12,
        maxBubbleWidthRatio: 0.78,
        horizontalPadding: 12,
        verticalPadding: 8,
        minSpacer: 40
    )

    static let compact = ChatLayout(
        messageSpacing: 8,
        maxBubbleWidthRatio: 0.85,
        horizontalPadding: 8,
        verticalPadding: 6,
        minSpacer: 24
    )
}
