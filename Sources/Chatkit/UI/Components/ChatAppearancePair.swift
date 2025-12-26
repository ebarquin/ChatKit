import SwiftUI

/// A pair of appearances for light and dark mode.
///
/// `ChatAppearancePair` does not generate or transform colors.
/// It simply selects the appropriate appearance based on the
/// current `ColorScheme`.
///
/// If `dark` is nil, the `light` appearance will be used for both modes.
public struct ChatAppearancePair: Sendable {

    public let light: ChatAppearance
    public let dark: ChatAppearance?

    /// Creates a pair of appearances for light and dark mode.
    ///
    /// - Parameters:
    ///   - light: Appearance used in light mode.
    ///   - dark: Optional appearance used in dark mode.
    ///           If nil, `light` will be reused.
    public init(
        light: ChatAppearance,
        dark: ChatAppearance? = nil
    ) {
        self.light = light
        self.dark = dark
    }

    /// Resolves the effective appearance for the given color scheme.
    ///
    /// - Parameter colorScheme: Current system color scheme.
    /// - Returns: The appearance that should be rendered.
    public func resolved(for colorScheme: ColorScheme) -> ChatAppearance {
        switch colorScheme {
        case .dark:
            return dark ?? light
        default:
            return light
        }
    }
}
