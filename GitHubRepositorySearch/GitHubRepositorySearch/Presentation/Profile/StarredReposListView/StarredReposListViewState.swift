//
//  StarredReposListViewState.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/10.
//

import SwiftUI
import IKEHGitHubAPIClient

@MainActor
@Observable
final class StarredReposListViewState {
    
    // MARK: - Public Property
    
    var asyncStarredRepoIDs: AsyncValues<Repo.ID, Error>
    var sortedBy: FetchStarredReposSortedBy
    var nextLink: RelationLink.Link?
    var error: Error?
    
    // MARK: - Private Property
    
    // MARK: Store
    
    private let loginUserStore: LoginUserStoreProtocol
    private let tokenStore: TokenStoreProtocol
    private let repoStore: RepoStoreProtocol
    private let starredRepoStore: StarredRepoStoreProtocol
        
    // MARK: - Computed Property
    
    var loginUser: LoginUser? {
        loginUserStore.loginUser
    }
    
    var asyncRepos: AsyncValues<Repo, Error> {
        let repos = asyncStarredRepoIDs.values.compactMap { repoStore.valuesDic[$0] }
        switch asyncStarredRepoIDs {
        case .initial:
            return .initial
        case .loading:
            return .loading(repos)
        case .loaded:
            return .loaded(repos)
        case .loadingMore:
            return .loadingMore(repos)
        case .error(let error, _):
            return .error(error, repos)
        }
    }
    
    var starredRepos: [StarredRepo] {
        asyncRepos.values.compactMap { starredRepoStore.valuesDic[$0.id] }
    }
    
    var repoCellStatusType: RepoCell.StatusType {
        switch sortedBy {
        case .recentlyStarred, .leastRecentlyStarred:
                .starredAt
        case .recentlyActive, .leastRecentlyActive:
                .updatedAt
        }
    }
    
    var nextLinkPage: Int? {
        guard let pageString = nextLink?.queryItems["page"],
              let page = Int(pageString) else {
            return nil
        }
        return page
    }
            
    // MARK: - LifeCycle
    
    init(
        loginUserStore: LoginUserStoreProtocol = LoginUserStore.shared,
        tokenStore: TokenStoreProtocol = TokenStore.shared,
        repoStore: RepoStoreProtocol = RepoStore.shared,
        starredRepoStore: StarredRepoStoreProtocol = StarredRepoStore.shared,
        asyncStarredRepoIDs: AsyncValues<Repo.ID, Error> = .initial,
        sortedBy: FetchStarredReposSortedBy = .recentlyStarred,
        nextLinkForFetchingStarredRepos: RelationLink.Link? = nil,
        error: Error? = nil
    ) {
        self.loginUserStore = loginUserStore
        self.tokenStore = tokenStore
        self.repoStore = repoStore
        self.starredRepoStore = starredRepoStore
        self.asyncStarredRepoIDs = asyncStarredRepoIDs
        self.sortedBy = sortedBy
        self.nextLink = nextLinkForFetchingStarredRepos
        self.error = error
    }
}

// MARK: - Fetch StarredRepos
 
extension StarredReposListViewState {
        
    /// スター済みリポジトリの取得
    /// - Parameters:
    ///   - page: ページ番号
    ///   - isLoadingMore: 続きを読み込むんでいるかどうか
    private func performFetchStarredRepos(page: Int? = nil, isLoadingMore: Bool = false) async {
                
        switch asyncStarredRepoIDs {
        case .initial, .loaded, .error:
            break
        case .loading, .loadingMore:
            return
        }
                
        guard let loginUser,
              let accessToken = await tokenStore.accessToken else {
            return
        }
        
        updateStatusBefore(isLoadingMore: isLoadingMore)
        do {
            let response = try await repoStore.fetchStarredRepos(
                userName: loginUser.login,
                accessToken: accessToken,
                sort: sortedBy.sort,
                direction: sortedBy.direction,
                perPage: 10,
                page: page
            )
            try await updateStatusAfter(with: response, isLoadingMore: isLoadingMore)
        } catch {
            // スター済みリポジトリの取得に失敗
            asyncStarredRepoIDs = .error(error, asyncStarredRepoIDs.values)
            self.error = error
        }
    }
    
    // MARK: - Helpers
    
    /// 通信前の状態の更新
    private func updateStatusBefore(isLoadingMore: Bool) {
        // 状態の更新
        asyncStarredRepoIDs = isLoadingMore ?
            .loadingMore(asyncStarredRepoIDs.values) :
            .loading(asyncStarredRepoIDs.values)
        nextLink = nil
    }
              
    // 通信後の状態の更新
    private func updateStatusAfter(with response: StarredReposResponse, isLoadingMore: Bool) async throws {
        // StarredRepoStoreの更新
        let newStarredRepos = response.starredRepos.map { StarredRepoTranslator.translate(from: $0) }
        try await starredRepoStore.addValues(newStarredRepos)
        
        // Viewのスター済みリポジトリのID一覧を更新
        let newIDs = newStarredRepos.map { $0.repoID }
        let combinedIDs = isLoadingMore ? (asyncStarredRepoIDs.values + newIDs) : newIDs
        withAnimation {
            asyncStarredRepoIDs = .loaded(combinedIDs)
        }
        nextLink = response.relationLink?.next
    }
}

// MARK: - Actions

extension StarredReposListViewState {
    
    /// スター済みリポジトリの取得
    func handleFetchStarredRepos() async {
        await performFetchStarredRepos()
    }
    
    /// スター済みリポジトリの取得(追加読み込み)
    func handleFetchStarredReposMore() async {
        guard let nextLinkPage else {
            return
        }
        await performFetchStarredRepos(page: nextLinkPage, isLoadingMore: true)
    }
    
    /// ソート順が変更された
    func handleSortedChanged() async {
        await performFetchStarredRepos()
    }
        
    func onAppear() async {
        // 初回読み込み時のみ検索を実行
        if asyncStarredRepoIDs != .initial {
            return
        }
        await performFetchStarredRepos()
    }
}
