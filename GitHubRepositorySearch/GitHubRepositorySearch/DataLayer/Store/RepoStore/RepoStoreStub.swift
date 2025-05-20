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
    var stubbedError: Error? // GitHub APIの処理でエラーを発生させる場合に値をセット
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
        await Task.yield() // テスト用に実行を1サイクル遅らせる
        try throwErrorIfNeeded()
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
        await Task.yield() // テスト用に実行を1サイクル遅らせる
        try throwErrorIfNeeded()
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
        await Task.yield() // テスト用に実行を1サイクル遅らせる
        try throwErrorIfNeeded()
        try await addValues(stubbedFetchStarredReposResponse.starredRepos.map { $0.repo })
        return stubbedFetchStarredReposResponse
    }
    
    private func throwErrorIfNeeded() throws {
        if Task.isCancelled {
            throw CancellationError()
        }
        if let stubbedError = stubbedError {
            throw stubbedError
        }
    }
}
