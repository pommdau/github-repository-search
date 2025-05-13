//
//  RepoStoreStub.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/12.
//

import Foundation
import IKEHGitHubAPIClient

@MainActor
@Observable
final class RepoStoreStub: RepoStoreProtocol {
    
    // MARK: - Property
    
    let repository: RepoRepository? = nil // Stubではデータの永続化を行わないのでnil
    var valuesDic: [Repo.ID: Repo] = [:]
    
    // MARK: Stubbed Response (GitHub API)
    
    var stubbedSearchReposResponse: SearchResponse<Repo> = .init(totalCount: .zero, items: [])
    var stubbedFetchUserReposResponse: ListResponse<Repo> = .init(items: [], relationLink: nil)
    var stubbedFetchStarredReposResponse: StarredReposResponse = .init(starredRepos: [])
    
    // MARK: - LifeCycle
    
    init(valuesDic: [Repo.ID: Repo] = [:]) {
        self.valuesDic = valuesDic
    }
}

// MARK: - GitHub API

extension RepoStoreStub {
    
    func searchRepos(
        searchText: String,
        accessToken: String?,
        sort: String?,
        order: String?,
        perPage: Int?,
        page: Int?
    ) async throws -> SearchResponse<Repo> {
        try await addValues(stubbedSearchReposResponse.items)
        return stubbedSearchReposResponse
    }
        
    func fetchUserRepos(
        userName: String,
        accessToken: String?,
        sort: String?,
        direction: String?,
        perPage: Int?,
        page: Int?
    ) async throws -> ListResponse<Repo> {
        try await addValues(stubbedFetchUserReposResponse.items)
        return stubbedFetchUserReposResponse
    }
    
    func fetchStarredRepos(
        userName: String,
        accessToken: String?,
        sort: String?,
        direction: String?,
        perPage: Int?,
        page: Int?
    ) async throws -> StarredReposResponse {
        try await addValues(stubbedFetchStarredReposResponse.starredRepos.map { $0.repo })
        return stubbedFetchStarredReposResponse
    }
}
