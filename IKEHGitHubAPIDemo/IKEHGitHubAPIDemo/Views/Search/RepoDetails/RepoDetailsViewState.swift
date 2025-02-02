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
    
    private(set) var checkIsStarredTask: Task<(), Never>?
    private(set) var starredTask: Task<(), Never>?
    
    private(set) var error: Error?
    
    var repo: Repo? {
        repoStore.valuesDic[repoID]
    }
    
    var loginUser: LoginUser? {
        loginUserStore.value
    }
    
    var disableStarButton: Bool {
        (loginUser == nil)
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
        starredTask = Task {
//            guard var repo else {
//                return
//            }
//            repo.isStarred.toggle()
//            // スター日時の更新
//            repo.starredAt = repo.isStarred ? ISO8601DateFormatter.shared.string(from: .now) : nil
//            try await repoStore.addValue(repo)
        }
    }
    
    func onAppear() {
        checkIsStarredTask = Task {
            guard let loginUser, let repo else {
                return
            }            
            do {
                let starred = try await gitHubAPIClient.checkIsRepoStarred(ownerName: loginUser.login, repoName: repo.name)                
                print(starred)
            } catch {
                self.error = error
            }
        }
    }
}
