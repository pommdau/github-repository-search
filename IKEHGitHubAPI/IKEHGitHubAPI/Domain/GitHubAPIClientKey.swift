import Foundation
import GitHubAPIClient
import Dependencies

private enum GitHubAPIClientKey: DependencyKey {
    /// アプリ実行時に利用される値
    static let liveValue: any GitHubAPIClientProtocol = GitHubAPIClient(
        clientID: GitHubAPICredentials.clientID,
        clientSecret: GitHubAPICredentials.clientSecret,
        // swiftlint:disable:next force_unwrapping
        callbackURL: URL(string: "ikehgithubapi://callback")!
    )
}

extension DependencyValues {
    /// DependencyValuesへの登録
    public var gitHubAPIClient: any GitHubAPIClientProtocol {
        get { self[GitHubAPIClientKey.self] }
        set { self[GitHubAPIClientKey.self] = newValue }
    }
}
