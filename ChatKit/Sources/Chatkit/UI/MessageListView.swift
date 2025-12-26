import SwiftUI

public struct MessageListView: View {

    let messages: [ChatMessage]
    let appearance: ChatAppearance
    let layout: ChatLayout
    let behavior: ChatBehavior

    public var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: layout.messageSpacing) {
                        ForEach(messages) { message in
                            MessageRowView(
                                message: message,
                                appearance: appearance,
                                layout: layout,
                                maxBubbleWidth: geometry.size.width * layout.maxBubbleWidthRatio
                            )
                            .transition(
                                .asymmetric(
                                    insertion: .move(
                                        edge: message.role == .assistant ? .leading : .trailing
                                    )
                                    .combined(with: .opacity),
                                    removal: .opacity
                                )
                            )
                        }

                        Color.clear
                            .frame(height: 1)
                            .id("bottom")
                    }
                    .padding(.top, layout.verticalPadding)
                    .padding(.bottom, layout.verticalPadding)
                    .animation(.easeOut(duration: 0.25), value: messages.count)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onChange(of: messages.count) { _ in
                    guard behavior.autoScroll else { return }

                    withAnimation(.easeOut(duration: 0.25)) {
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
            }
        }
    }
}
