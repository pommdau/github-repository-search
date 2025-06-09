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
    
    // MARK: - Property

    static var shared: RepoStore = .init()
    let repository: RepoRepository?
    var valuesDic: [Repo.ID: Repo] = [:]
    
    private let gitHubAPIClient: GitHubAPIClientProtocol
    
    // MARK: - LifeCycle
    
    init(
        repository: RepoRepository? = .shared,
        gitHubAPIClient: GitHubAPIClientProtocol = GitHubAPIClient.shared
    ) {
        self.repository = repository
        self.gitHubAPIClient = gitHubAPIClient
        Task {
            try? await self.loadSavedValues()
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
            query: searchText,
            accessToken: accessToken,
            sort: sort,
            order: order,
            perPage: perPage,
            page: page
        )
        try await addValues(response.items)
        return response
    }
        
    func fetchAuthenticatedUserRepos(
        accessToken: String,
        sort: String?,
        direction: String?,
        perPage: Int?,
        page: Int?
    ) async throws -> ListResponse<Repo> {
        
        let response = try await gitHubAPIClient.fetchAuthenticatedUserRepos(
            accessToken: accessToken,
            visibility: nil,
            affiliation: nil,
            type: nil,
            sort: sort,
            direction: direction,
            perPage: perPage,
            page: page,
            since: nil,
            before: nil
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
        try await addValues(response.starredRepos.map { $0.repo })
        return response
    }
}
