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
    var valuesDic: [StarredRepo.ID: StarredRepo] = [:]

    private let gitHubAPIClient: GitHubAPIClient
    
    // MARK: - LifeCycle
    
    init(
        repository: StarredRepoRepository? = .shared,
        gitHubAPIClient: GitHubAPIClient = GitHubAPIClient.shared
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
        repoID: Repo.ID,
        accessToken: String,
        owner: String,
        repo: String
    ) async throws -> Bool {
        let isStarred = try await gitHubAPIClient.checkIsRepoStarred(
            accessToken: accessToken,
            owner: owner,
            repo: repo
        )
        try await addValue(
            .init(
                repoID: repoID,
                // スター済みでかつ既にローカルにスター日時の情報を持っている場合はそれを利用する
                starredAt: isStarred ? valuesDic[repoID]?.starredAt : nil,
                isStarred: isStarred
            )
        )
        return isStarred
    }
    
    func starRepo(
        repoID: Repo.ID,
        accessToken: String,
        owner: String,
        repo: String,
    ) async throws {
        try await gitHubAPIClient.starRepo(
            accessToken: accessToken,
            owner: owner,
            repo: repo,
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
        owner: String,
        repo: String,
    ) async throws {
        try await gitHubAPIClient.unstarRepo(
            accessToken: accessToken,
            owner: owner,
            repo: repo,
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
