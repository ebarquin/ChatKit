import ChatKit

final class FakeLLMClient {

    func handle(
        message: ChatMessage,
        into viewModel: ChatViewModel
    ) {
        Task {
            // Simula latencia
            try await Task.sleep(for: .seconds(1))

            // Ejemplo: una o varias respuestas
            viewModel.appendMessage(
                ChatMessage(
                    role: .assistant,
                    content: "Respuesta a: \(message.content)",
                    status: .completed
                )
            )
        }
    }
}
