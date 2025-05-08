//
//  RepoStore.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import Foundation
import IKEHGitHubAPIClient

@MainActor
@Observable
final class RepoStore: RepoStoreProtocol {
    static var shared: RepoStore = .init()
    var repository: RepoRepository?
    var valuesDic: [Repo.ID: Repo] = [:]
    let gitHubAPIClient: GitHubAPIClientProtocol
    
    // MARK: - LifeCycle
    
    init(
        repository: RepoRepository? = .shared,
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

extension RepoStore {
    
    func searchRepos(
        searchText: String,
        accessToken: String?,
        sort: String?,
        order: String?,
        perPage: Int?,
        page: Int?
    ) async throws -> SearchResponse<Repo> {
        let response = try await gitHubAPIClient.searchRepos(
            searchText: searchText,
            accessToken: accessToken,
            sort: sort,
            order: order,
            perPage: perPage,
            page: page
        )
        try await addValues(response.items)
        return response
    }
    
    func fetchStarredRepos(
        userName: String,
        accessToken: String?,
        sort: String?,
        direction: String?,
        perPage: Int?,
        page: Int?
    ) async throws -> StarredReposResponse {
        let response = try await gitHubAPIClient.fetchStarredRepos(
            userName: userName,
            accessToken: accessToken,
            sort: sort,
            direction: direction,
            perPage: perPage,
            page: page
        )
//        try await addValues(response.starredRepos.map { StarredRepoTranslator.translate(from: $0) })
        try await addValues(response.starredRepos.map { $0.repo })
        return response
    }
}
