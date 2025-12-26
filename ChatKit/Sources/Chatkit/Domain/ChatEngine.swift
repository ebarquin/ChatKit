import Foundation

// MARK: - Engine Events

public enum ChatEvent {
    case started
    case token(String)
    case completed
    case failed(Error)
    case cancelled
}

// MARK: - Engine Contract

public protocol ChatEngine {
    func send(
        _ input: String
    ) -> AsyncThrowingStream<ChatEvent, Error>
}
