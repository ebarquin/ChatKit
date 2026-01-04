import XCTest
@testable import ChatKit

@MainActor
final class ChatViewModelTests: XCTestCase {

    // MARK: - Helpers

    private func makeViewModel(
        initialMessages: [ChatMessage] = [],
        onSend: ((ChatMessage) -> Void)? = nil
    ) -> ChatViewModel {
        ChatViewModel(
            initialMessages: initialMessages,
            quickPrompts: [],
            onSend: onSend ?? { _ in }
        )
    }

    // MARK: - sendUserText

    func test_sendUserText_appendsUserMessage_andCallsOnSend() {
        // Arrange
        var sentMessage: ChatMessage?

        let viewModel = makeViewModel { message in
            sentMessage = message
        }

        // Act
        viewModel.sendUserText("Hello")

        // Assert
        XCTAssertEqual(viewModel.messages.count, 2)

        let userMessage = viewModel.messages.first
        XCTAssertEqual(userMessage?.role, .user)
        XCTAssertEqual(userMessage?.content, "Hello")

        let assistantMessage = viewModel.messages.dropFirst().first
        XCTAssertEqual(assistantMessage?.role, .assistant)
        // Accepts empty or placeholder content for assistant
        XCTAssertTrue(assistantMessage?.content.isEmpty ?? false)

        XCTAssertNotNil(sentMessage)
        XCTAssertEqual(sentMessage?.content, "Hello")
    }

    // MARK: - appendMessage

    func test_appendAssistantMessage_setsPhaseReady() {
        let viewModel = makeViewModel()

        _ = viewModel.beginAwaitingAssistant()
        XCTAssertNotEqual(viewModel.phase, .ready)

        viewModel.appendMessage(
            ChatMessage(role: .assistant, content: "Hi")
        )

        XCTAssertEqual(viewModel.phase, .ready)
        XCTAssertEqual(viewModel.messages.count, 1)
    }

    func test_appendUserMessage_doesNotChangePhase() {
        let viewModel = makeViewModel()

        _ = viewModel.beginAwaitingAssistant()

        viewModel.appendMessage(
            ChatMessage(role: .user, content: "Hello")
        )

        XCTAssertEqual(viewModel.phase, .awaitingAssistant)
    }

    // MARK: - appendMessages

    func test_appendMessages_preservesOrder() {
        let viewModel = makeViewModel()

        let messages: [ChatMessage] = [
            ChatMessage(role: .user, content: "A"),
            ChatMessage(role: .assistant, content: "B"),
            ChatMessage(role: .user, content: "C")
        ]

        viewModel.appendMessages(messages)

        XCTAssertEqual(viewModel.messages.map(\.content), ["A", "B", "C"])
    }

    func test_appendMessages_setsPhaseReady_ifAnyAssistantMessageExists() {
        let viewModel = makeViewModel()
        _ = viewModel.beginAwaitingAssistant()

        let messages: [ChatMessage] = [
            ChatMessage(role: .user, content: "A"),
            ChatMessage(role: .assistant, content: "B")
        ]

        viewModel.appendMessages(messages)

        XCTAssertEqual(viewModel.phase, .ready)
    }

    func test_appendMessages_doesNotChangePhase_ifNoAssistantMessageExists() {
        let viewModel = makeViewModel()
        _ = viewModel.beginAwaitingAssistant()

        let messages: [ChatMessage] = [
            ChatMessage(role: .user, content: "A"),
            ChatMessage(role: .user, content: "B")
        ]

        viewModel.appendMessages(messages)

        XCTAssertEqual(viewModel.phase, .awaitingAssistant)
    }

    // MARK: - Error handling

    func test_setError_setsErrorPhase() {
        let viewModel = makeViewModel()

        viewModel.setError("Network error")

        if case .error(let message) = viewModel.phase {
            XCTAssertEqual(message, "Network error")
        } else {
            XCTFail("Expected error phase")
        }
    }

    func test_resetError_setsPhaseReady() {
        let viewModel = makeViewModel()

        viewModel.setError("Error")
        viewModel.resetError()

        XCTAssertEqual(viewModel.phase, .ready)
    }

    // MARK: - Placeholder completion behavior

    func test_completingAssistantPlaceholder_doesNotAppendNewAssistant() {
        // Arrange
        let viewModel = makeViewModel()

        // Act
        viewModel.sendUserText("Hello")

        XCTAssertEqual(viewModel.messages.count, 2)

        let placeholder = viewModel.messages.last
        XCTAssertEqual(placeholder?.role, .assistant)
        XCTAssertTrue(placeholder?.content.isEmpty ?? false)

        // Simulate LLM completing the response by updating the existing assistant
        viewModel.completeAssistantMessage(
            id: placeholder!.id,
            content: "Hi there"
        )

        // Assert
        XCTAssertEqual(viewModel.messages.count, 2)
        XCTAssertEqual(viewModel.messages.last?.content, "Hi there")
    }
}
