//
//  StarredRepoStoreStub.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/13.
//

import Foundation
import IKEHGitHubAPIClient

@MainActor
@Observable
final class StarredRepoStoreStub: StarredRepoStoreProtocol {

    // MARK: - Property
    
    let repository: StarredRepoRepository? = nil // Stubではデータの永続化を行わないのでnil
    var valuesDic: [StarredRepo.ID: StarredRepo] = [:]
    
    // MARK: Stubbed Response (GitHub API)
    
    var stubbedCheckIsRepoStarredResponse: Bool = false
    
    // MARK: - LifeCycle
    
    init(valuesDic: [StarredRepo.ID: StarredRepo] = [:]) {
        self.valuesDic = valuesDic
    }
}

// MARK: - GitHub API

extension StarredRepoStoreStub {
    
    func checkIsRepoStarred(repoID: IKEHGitHubAPIClient.Repo.ID, accessToken: String, owner: String, repo: String) async throws -> Bool {
        stubbedCheckIsRepoStarredResponse
    }
    
    func starRepo(repoID: IKEHGitHubAPIClient.Repo.ID, accessToken: String, owner: String, repo: String) async throws {}
    
    func unstarRepo(repoID: IKEHGitHubAPIClient.Repo.ID, accessToken: String, owner: String, repo: String) async throws {}
}
