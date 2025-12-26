import SwiftUI

public struct QuickPromptBarView: View {

    let prompts: [QuickPrompt]
    let appearance: ChatAppearance
    let onSelect: (QuickPrompt) -> Void

    public init(
        prompts: [QuickPrompt],
        appearance: ChatAppearance,
        onSelect: @escaping (QuickPrompt) -> Void
    ) {
        self.prompts = prompts
        self.appearance = appearance
        self.onSelect = onSelect
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(prompts) { prompt in
                    QuickPromptButtonView(
                        prompt: prompt,
                        appearance: appearance,
                        action: {
                            onSelect(prompt)
                        }
                    )
                }
            }
            .padding(.horizontal, appearance.contentPadding)
            .padding(.vertical, 8)
        }
        .background(
            appearance.background
                .opacity(0.95)
        )
    }
}
