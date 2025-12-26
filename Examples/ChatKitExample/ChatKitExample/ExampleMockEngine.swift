import ChatKit
import Foundation

final class ExampleMockEngine: ChatEngine {

    func send(_ input: String) -> AsyncThrowingStream<ChatEvent, Error> {
        AsyncThrowingStream { continuation in
            Task {
                continuation.yield(.started)

                let words = input.split(separator: " ")

                for word in words {
                    try? await Task.sleep(for: .milliseconds(120))
                    continuation.yield(.token(String(word) + " "))
                }

                continuation.yield(.completed)
                continuation.finish()
            }
        }
    }
}
