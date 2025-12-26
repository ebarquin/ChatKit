import Foundation

public struct RenderPolicy {
    /// Tiempo mínimo entre renders
    let minInterval: Duration

    /// Número máximo de tokens acumulados antes de forzar render
    let maxChunkSize: Int

    public static let `default` = RenderPolicy(
        minInterval: .milliseconds(40),
        maxChunkSize: 12
    )
}

