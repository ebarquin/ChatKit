import SwiftUI

/// Visual indicator shown while the assistant response is pending.
/// This view is NOT part of the message list and does not affect chat history.
struct TypingIndicatorRowView: View {

    let appearance: ChatAppearance
    let layout: ChatLayout

    var body: some View {
        HStack {
            TypingIndicatorView()
                .padding(appearance.contentPadding)
                .background(appearance.assistantBubble.background)
                .cornerRadius(appearance.assistantBubble.cornerRadius)

            Spacer(minLength: layout.minSpacer)
        }
        .padding(.horizontal, layout.horizontalPadding)
        .padding(.vertical, layout.verticalPadding)
    }
}
