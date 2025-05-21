//
//  RepoDetailsViewState.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/09.
//

import Foundation
import IKEHGitHubAPIClient

@MainActor
@Observable
final class RepoDetailsViewState {
    
    // MARK: - Public Property
    
    let repoID: Repo.ID
    var isFetchingStarred: Bool = false
    var error: Error?
    
    // MARK: - Private Property
    
    private var isUpdatingStarred: Bool = false
    
    // MARK: Store
    
    private let loginUserStore: LoginUserStoreProtocol
    private let tokenStore: TokenStoreProtocol
    private let repoStore: RepoStoreProtocol
    private let starredRepoStore: StarredRepoStoreProtocol
        
    // MARK: - Computed Property
    
    var repo: Repo? {
        repoStore.valuesDic[repoID]
    }
    
    var loginUser: LoginUser? {
        loginUserStore.loginUser
    }
    
    var disableStarButton: Bool {
        (loginUser == nil) ||
        isFetchingStarred ||
        isUpdatingStarred
    }
    
    var isStarred: Bool {
        starredRepoStore.valuesDic[repoID]?.isStarred ?? false
    }
    
    // MARK: - LifeCycle
        
    init(
        repoID: Repo.ID,
        tokenStore: TokenStoreProtocol = TokenStore.shared,
        loginUserStore: LoginUserStoreProtocol = LoginUserStore.shared,
        repoStore: RepoStoreProtocol = RepoStore.shared,
        starredRepoStore: StarredRepoStoreProtocol = StarredRepoStore.shared
    ) {
        self.repoID = repoID
        self.tokenStore = tokenStore
        self.loginUserStore = loginUserStore
        self.repoStore = repoStore
        self.starredRepoStore = starredRepoStore
    }
}

// MARK: - Actions

extension RepoDetailsViewState {
    
    func onAppear() {
        Task {
            await checkIfRepoIsStarred()
        }
    }
    
    func handleStarButtonTapped() {
        // すでに処理中の場合は何もしない
        if isUpdatingStarred {
            return
        }
        Task {
            await updateStarred()
        }
    }
}

// MARK: - Star Methods

extension RepoDetailsViewState {
        
    private func checkIfRepoIsStarred() async {
        // 必要な情報の確認
        guard let repo,
              loginUser != nil,
              let accessToken = await tokenStore.accessToken
        else {
            return
        }
        // 状態の更新
        isFetchingStarred = true
        defer {
            isFetchingStarred = false
        }
        
        // スター状態の取得
        do {
            try await starredRepoStore.checkIsRepoStarred(
                repoID: repo.id,
                accessToken: accessToken,
                owner: repo.owner.login,
                repo: repo.name
            )
        } catch {
            self.error = error
        }
    }
        
    private func updateStarred() async {
        
        // 必要な情報の確認
        guard let repo,
              let accessToken = await tokenStore.accessToken
        else {
            return
        }
        
        // 状態の更新
        isUpdatingStarred = true
        defer {
            isUpdatingStarred = false
        }
        
        // スター状態を更新
        let currentIsStarred = isStarred
        let currentStarsCount = repo.starsCount
        do {
            if isStarred {
                // スターを取り消す
                // 一時的に値を更新する(ユーザにアクションの完了を意識させない工夫)
                try await repoStore.update(repoID: repo.id, starsCount: max(currentStarsCount - 1, .zero)) // スター数は0未満にならない
                try await starredRepoStore.update(repoID: repoID, isStarred: false)
                // 実際の更新処理
                try await starredRepoStore.unstarRepo(repoID: repoID, accessToken: accessToken, owner: repo.owner.login, repo: repo.name)
            } else {
                // スターをつける
                // 一時的に値を更新する(ユーザにアクションの完了を意識させない工夫)
                try await repoStore.update(repoID: repo.id, starsCount: currentStarsCount + 1)
                try await starredRepoStore.update(repoID: repoID, isStarred: true)
                // 実際の更新処理
                try await starredRepoStore.starRepo(repoID: repoID, accessToken: accessToken, owner: repo.owner.login, repo: repo.name)
            }
        } catch {
            // 一時的に値を更新していたスターの状態をもとに戻す
            try? await starredRepoStore.update(repoID: repoID, isStarred: currentIsStarred)
            try? await repoStore.update(repoID: repo.id, starsCount: currentStarsCount)
            self.error = error
        }
    }
}
