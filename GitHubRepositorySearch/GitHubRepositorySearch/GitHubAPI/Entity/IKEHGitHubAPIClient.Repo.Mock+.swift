import Foundation
import IKEHGitHubAPIClient

extension IKEHGitHubAPIClient.Repo.Mock {

    // MARK: - 固定値のMock
    
    static let privateRepo: Repo =
        .init(id: 44838949,
              name: "SampleRepository",
              fullName: "IKEH/SampleRepository",
              isPrivate: true,
              owner: User.Mock.random(),
              starsCount: 61080,
              watchersCount: 2100,
              forksCount: 9815,
              openIssuesCount: 6175,
              language: "C++",
              htmlPath: "https://github.com/apple/swift/ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
              websitePath: "https://www.swift.org/ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
              description: String(repeating: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", count: 5),
              createdAt: ISO8601DateFormatter.shared.string(from: Date.random(inPastYears: 10)),
              updatedAt: ISO8601DateFormatter.shared.string(from: Date.random(inPastYears: 10)),
              pushedAt: ISO8601DateFormatter.shared.string(from: Date.random(inPastYears: 10))
        )
    
    static let sampleDataWithLongWord: Repo =
        .init(id: 44838949,
              name: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
              fullName: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
              isPrivate: false,
              owner: User.Mock.random(),
              starsCount: 61080,
              watchersCount: 2100,
              forksCount: 9815,
              openIssuesCount: 6175,
              language: "C++",
              htmlPath: "https://github.com/apple/swift/ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
              websitePath: "https://www.swift.org/ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
              description: String(repeating: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", count: 5),
              createdAt: ISO8601DateFormatter.shared.string(from: Date.random(inPastYears: 10)),
              updatedAt: ISO8601DateFormatter.shared.string(from: Date.random(inPastYears: 10)),
              pushedAt: ISO8601DateFormatter.shared.string(from: Date.random(inPastYears: 10))
        )
    
    static let sampleDataWithoutSomeInfo: Repo =
        .init(id: 44838949,
              name: "swift",
              fullName: "apple/swift",
              isPrivate: false,
              owner: User.Mock.random(),
              starsCount: 61308,
              watchersCount: 61308,
              forksCount: 9858,
              openIssuesCount: 6244,
              language: nil,
              htmlPath: "https://github.com/apple/swift",
              websitePath: nil,
              description: nil,
              createdAt: ISO8601DateFormatter.shared.string(from: Date.random(inPastYears: 10)),
              updatedAt: ISO8601DateFormatter.shared.string(from: Date.random(inPastYears: 10)),
              pushedAt: ISO8601DateFormatter.shared.string(from: Date.random(inPastYears: 10))
        )
    
    static let skeltonRepoCell = Repo(
        id: 44838949,
        name: "Lorem ipsum dol",
        fullName: "apple/swift",
        isPrivate: false,
        owner: User(
            id: 99999,
            login: "login-name",
            avatarImagePath: "https://avatars.githubusercontent.com/u/29433103?v=4"
        ),
        starsCount: 61308,
        watchersCount: 61308,
        forksCount: 9858,
        openIssuesCount: 6244,
        language: "",
        htmlPath: "https://github.com/apple/swift",
        websitePath: "https://swift.org",
        description: """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. 
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
""",
        createdAt: ISO8601DateFormatter.shared.string(from: Date.random(inPastYears: 10)),
        updatedAt: ISO8601DateFormatter.shared.string(from: Date.random(inPastYears: 10)),
        pushedAt: ISO8601DateFormatter.shared.string(from: Date.random(inPastYears: 10))
    )
}
