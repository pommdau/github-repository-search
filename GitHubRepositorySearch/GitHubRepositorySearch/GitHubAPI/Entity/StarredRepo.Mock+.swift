import Foundation
import IKEHGitHubAPIClient

extension IKEHGitHubAPIClient.StarredRepo {
    enum Mock {
        /// [Repo]の情報から[IKEHGitHubAPIClient.StarredRepo]を作成
        static func randomWithRepos(_ repos: [Repo]) -> [IKEHGitHubAPIClient.StarredRepo] {
            repos.map { repo in
                IKEHGitHubAPIClient.StarredRepo(
                    starredAt: ISO8601DateFormatter.shared.string(from: Date.random(inPastYears: 3)),
                    repo: repo
                )
            }
        }
    }
}
