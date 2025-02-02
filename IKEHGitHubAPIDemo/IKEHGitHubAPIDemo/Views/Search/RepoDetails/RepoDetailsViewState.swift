//
//  RepoDetailsViewState.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/03.
//

import SwiftUI

@MainActor @Observable
final class RepoDetailsViewState {
    
    // MARK: - Property
    
    let gitHubAPIClient: GitHubAPIClient
    let repoStore: RepoStore
    let loginUserStore: LoginUserStore
    let repoID: Repo.ID
    
    private var checkIsStarredTask: Task<(), Never>?
    private var starredTask: Task<(), Never>?

    private var checkIsStarredInProcessing: Bool = false
    private var starredInProcessing: Bool = false
    
    private(set) var error: Error?
    
    var repo: Repo? {
        repoStore.valuesDic[repoID]
    }
    
    var loginUser: LoginUser? {
        loginUserStore.value
    }
    
    var disableStarButton: Bool {
        (loginUser == nil) ||
        checkIsStarredInProcessing ||
        starredInProcessing
    }
    
    // MARK: - LifeCycle
        
    init(
        repoID: Repo.ID,
        gitHubAPIClient: GitHubAPIClient = .shared,
        repoStore: RepoStore = .shared,
        loginUserStore: LoginUserStore = .shared
    ) {
        self.repoID = repoID
        self.gitHubAPIClient = gitHubAPIClient
        self.repoStore = repoStore
        self.loginUserStore = loginUserStore
    }
    
    func handleStarButtonTapped() {
        guard var repo, let loginUser else {
            return
        }
        let isStarred = repo.isStarred
                
        starredTask = Task {
            // UI更新
            starredInProcessing = true
            defer {
                starredInProcessing = false
            }
            
            // API通信
            do {
                if isStarred {
                    try await gitHubAPIClient.unstarRepo(ownerName: loginUser.login, repoName: repo.name)
                } else {
                    try await gitHubAPIClient.starRepo(ownerName: loginUser.login, repoName: repo.name)
                    
                }
            } catch {
                self.error = error
                return
            }
            
            // ローカルの情報の更新
            repo.isStarred.toggle()
            // スター日時の更新
            repo.starredAt = repo.isStarred ? ISO8601DateFormatter.shared.string(from: .now) : nil
            do {
                try await repoStore.addValue(repo)
            } catch {
                self.error = error
                return
            }
        }
    }
    
    func checkIsStarred() {
        guard var repo, let loginUser else {
            return
        }
        checkIsStarredTask = Task {
            // UI更新
            checkIsStarredInProcessing = true
            defer {
                checkIsStarredInProcessing = false
            }
            
            // API通信
            let isStarred: Bool
            do {
                isStarred = try await gitHubAPIClient.checkIsRepoStarred(ownerName: loginUser.login, repoName: repo.name)
            } catch {
                self.error = error
                return
            }
            
            // ローカルの情報の更新
            repo.isStarred = isStarred
            do {
                try await repoStore.addValue(repo)
            } catch {
                self.error = error
                return
            }
        }
    }
}
