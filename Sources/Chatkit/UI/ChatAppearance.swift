import SwiftUI

/// Visual styling for ChatKit.
///
/// `ChatAppearance` is a pure styling container.
/// It does NOT:
/// - infer light/dark mode automatically
/// - transform or generate colors
/// - read environment values
///
/// If your app supports light/dark mode, provide two appearances
/// and use `ChatAppearancePair` to select between them.
public struct ChatAppearance: Sendable {

    public let background: Color
    public let font: Font
    public let contentPadding: CGFloat

    public let userBubble: BubbleStyle
    public let assistantBubble: BubbleStyle

    public init(
        background: Color,
        font: Font,
        contentPadding: CGFloat,
        userBubble: BubbleStyle,
        assistantBubble: BubbleStyle
    ) {
        self.background = background
        self.font = font
        self.contentPadding = contentPadding
        self.userBubble = userBubble
        self.assistantBubble = assistantBubble
    }

    /// Convenience initializer for mapping brand design-system colors directly.
    ///
    /// This initializer is intended for app-level integration where colors
    /// come from a design system or asset catalog.
    /// For dark mode support, create a separate `ChatAppearance` and
    /// pair them using `ChatAppearancePair`.
    public init(
        background: Color,
        font: Font = .body,
        contentPadding: CGFloat = 12,
        userBubbleBackground: Color,
        assistantBubbleBackground: Color,
        userForeground: Color = .primary,
        assistantForeground: Color = .primary,
        cornerRadius: CGFloat = 12
    ) {
        self.background = background
        self.font = font
        self.contentPadding = contentPadding
        self.userBubble = BubbleStyle(
            background: userBubbleBackground,
            foreground: userForeground,
            cornerRadius: cornerRadius
        )
        self.assistantBubble = BubbleStyle(
            background: assistantBubbleBackground,
            foreground: assistantForeground,
            cornerRadius: cornerRadius
        )
    }
}

// MARK: - Presets

/// Preset appearances provided as examples and defaults.
///
/// These presets are NOT themes and are not intended to fit all products.
/// Most real apps should provide their own `ChatAppearance`.
public extension ChatAppearance {

    static let `default` = ChatAppearance(
        background: Color(.systemBackground),
        font: .body,
        contentPadding: 12,
        userBubble: BubbleStyle(
            background: .blue.opacity(0.15),
            foreground: .primary,
            cornerRadius: 12
        ),
        assistantBubble: BubbleStyle(
            background: .gray.opacity(0.12),
            foreground: .primary,
            cornerRadius: 12
        )
    )

    static let dark = ChatAppearance(
        background: .black,
        font: .body,
        contentPadding: 12,
        userBubble: BubbleStyle(
            background: .blue.opacity(0.35),
            foreground: .white,
            cornerRadius: 12
        ),
        assistantBubble: BubbleStyle(
            background: .white.opacity(0.10),
            foreground: .white,
            cornerRadius: 12
        )
    )
}

// MARK: - BubbleStyle

public struct BubbleStyle: Sendable {
    public let background: Color
    public let foreground: Color
    public let cornerRadius: CGFloat

    public init(
        background: Color,
        foreground: Color,
        cornerRadius: CGFloat
    ) {
        self.background = background
        self.foreground = foreground
        self.cornerRadius = cornerRadius
    }
}
