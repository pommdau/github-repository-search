//
//  RepoStoreProtocol.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import Foundation
import IKEHGitHubAPIClient

@MainActor
protocol RepoStoreProtocol: AnyObject {
    
    // MARK: - Property
    
    var repository: RepoRepository? { get }
    var valuesDic: [Repo.ID: Repo] { get set }
            
    // MARK: - GitHub API
    
    /// レポジトリの検索
    func searchRepos(
        searchText: String,
        accessToken: String?,
        sort: String?,
        order: String?,
        perPage: Int?,
        page: Int?
    ) async throws -> SearchResponse<Repo>
    
    /// ユーザのリポジトリを取得
    func fetchUserRepos(
        userName: String,
        accessToken: String?,
        sort: String?,
        direction: String?,
        perPage: Int?,
        page: Int?
    ) async throws -> ListResponse<Repo>
    
    /// ユーザのスター済みリポジトリを取得
    func fetchStarredRepos(
        userName: String,
        accessToken: String?,
        sort: String?,
        direction: String?,
        perPage: Int?,
        page: Int?
    ) async throws -> StarredReposResponse
}

// MARK: - Computed Property

extension RepoStoreProtocol {
    var repos: [Repo] {
        Array(valuesDic.values)
    }
}

// MARK: - CRUD

extension RepoStoreProtocol {
    
    // MARK: Create/Update

    func addValue(_ value: Repo) async throws {
        try await addValues([value])
    }
    
    func addValues(_ values: [Repo]) async throws {
        try await repository?.addValues(values)
        valuesDic.registerValues(values)
    }
    
    // MARK: Update
        
    /// ローカルのスター数の情報を更新
    func update(repoID: Repo.ID, starsCount: Int) async throws {
        guard var repo = valuesDic[repoID] else {
            return
        }
        repo.starsCount = starsCount
        try await addValue(repo)
    }
    
    // MARK: Read
    
    func fetchValues() async throws {
        guard let repository else {
            return
        }
        let values = try await repository.fetchValuesAll()
        valuesDic.registerValues(values)
    }

    // MARK: Delete

    func deleteAllValues() async throws {
        try await repository?.deleteAll()
        valuesDic.removeAll()
    }
}

