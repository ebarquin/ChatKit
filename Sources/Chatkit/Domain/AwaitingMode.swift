public enum AwaitingMode: Sendable {
    /// ChatKit manages awaiting state assuming a single
    /// user → single assistant response flow.
    case automatic

    /// Consumer fully controls awaiting state via
    /// startAwaitingAssistant / stopAwaitingAssistant.
    case manual
}
