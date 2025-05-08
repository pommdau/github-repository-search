//
//  StarredRepoStore.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/07.
//

import Foundation
import IKEHGitHubAPIClient

@MainActor
@Observable
final class StarredRepoStore: StarredRepoStoreProtocol {
    static var shared: StarredRepoStore = .init()
    var repository: StarredRepoRepository?
    var valuesDic: [SwiftID<StarredRepo>: StarredRepo] = [:]
    let gitHubAPIClient: GitHubAPIClientProtocol
    
    // MARK: - LifeCycle
    
    init(
        repository: StarredRepoRepository? = .shared,
        gitHubAPIClient: GitHubAPIClientProtocol = GitHubAPIClient.shared
    ) {
        self.repository = repository
        self.gitHubAPIClient = gitHubAPIClient
        Task {
            try? await self.fetchValues()
        }
    }
}

// MARK: - GitHub API

extension StarredRepoStore {
    
    @discardableResult
    func checkIsRepoStarred(
        repoID: SwiftID<Repo>,
        accessToken: String,
        ownerName: String,
        repoName: String
    ) async throws -> Bool {
        let isStarred = try await gitHubAPIClient.checkIsRepoStarred(
            accessToken: accessToken,
            ownerName: ownerName,
            repoName: repoName
        )
        let starredRepoID: SwiftID<StarredRepo> = .init(rawValue: repoID.rawValue)
        try await addValue(
            .init(
                repoID: repoID,
                starredAt: valuesDic[starredRepoID]?.starredAt,
                isStarred: isStarred
            )
        )
        return isStarred
    }
    
    func starRepo(
        repoID: Repo.ID,
        accessToken: String,
        ownerName: String,
        repoName: String,
    ) async throws {
        try await gitHubAPIClient.starRepo(
            accessToken: accessToken,
            ownerName: ownerName,
            repoName: repoName,
        )
        try await addValue(
            StarredRepo(
                repoID: repoID,
                starredAt: ISO8601DateFormatter.shared.string(from: .now),
                isStarred: true)
        )
    }
    
    func unstarRepo(
        repoID: Repo.ID,
        accessToken: String,
        ownerName: String,
        repoName: String,
    ) async throws {
        try await gitHubAPIClient.unstarRepo(
            accessToken: accessToken,
            ownerName: ownerName,
            repoName: repoName,
        )
        try await addValue(
            StarredRepo(
                repoID: repoID,
                starredAt: nil,
                isStarred: false
            )
        )
    }    
}
