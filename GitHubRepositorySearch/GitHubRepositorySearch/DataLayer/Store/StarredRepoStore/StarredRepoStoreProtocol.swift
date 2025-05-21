//
//  StarredRepoStoreProtocol.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/07.
//

import Foundation
import IKEHGitHubAPIClient

@MainActor
protocol StarredRepoStoreProtocol: AnyObject {
    
    // MARK: - Property
    
    var repository: StarredRepoRepository? { get }
    var valuesDic: [StarredRepo.ID: StarredRepo] { get set }
    
    // MARK: - GitHub API
    
    @discardableResult
    func checkIsRepoStarred(
        repoID: Repo.ID,
        accessToken: String,
        owner: String,
        repo: String
    ) async throws -> Bool
    
    func starRepo(
        repoID: Repo.ID,
        accessToken: String,
        owner: String,
        repo: String
    ) async throws
    
    func unstarRepo(
        repoID: Repo.ID,
        accessToken: String,
        owner: String,
        repo: String
    ) async throws
}

// MARK: - Computed Property

extension StarredRepoStoreProtocol {
    var repos: [StarredRepo] {
        Array(valuesDic.values)
    }
}

// MARK: - CRUD

extension StarredRepoStoreProtocol {
            
    // MARK: Create/Update

    func addValue(_ value: StarredRepo) async throws {
        try await addValues([value])
    }
    
    func addValues(_ values: [StarredRepo]) async throws {
        try await repository?.addValues(values)
        valuesDic.registerValues(values)
    }
    
    // MARK: Update
    
    /// ローカルのスター状態の更新
    func update(repoID: Repo.ID, isStarred: Bool, starredAt: String = ISO8601DateFormatter.shared.string(from: .now)) async throws {
        try await addValue(
            .init(
                repoID: repoID,
                starredAt: isStarred ? starredAt : nil,
                isStarred: isStarred
            )
        )
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
