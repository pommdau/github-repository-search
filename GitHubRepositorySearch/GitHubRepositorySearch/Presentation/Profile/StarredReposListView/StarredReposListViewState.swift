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
    
    // MARK: Stores
    let loginUserStore: LoginUserStore = .shared
    let tokenStore: TokenStore = .shared
    let repoStore: RepoStore = .shared
    let starredRepoStore: StarredRepoStore = .shared
        
    var asyncStarredRepoIDs: AsyncValues<Repo.ID, Error> = .initial
    var nextLinkForFetchingStarredRepos: RelationLink.Link?
    var sortedBy: FetchStarredReposSortedBy = .recentlyStarred
    var error: Error?
    
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
    
    // MARK: - Actions
    
    private func performFetchStarrredRepos(isLoadingMore: Bool, page: Int?) {
        Task {
            // 必要な情報のチェック
            guard let loginUser,
                  let accessToken = await tokenStore.accessToken
            else {
                return
            }
            // 状態の更新
            asyncStarredRepoIDs = isLoadingMore ?
                .loadingMore(asyncStarredRepoIDs.values) :
                .loading(asyncStarredRepoIDs.values)
            nextLinkForFetchingStarredRepos = nil
            
            do {
                let response = try await repoStore.fetchStarredRepos(
                    userName: loginUser.login,
                    accessToken: accessToken,
                    sort: sortedBy.sort,
                    direction: sortedBy.direction,
                    perPage: 10,
                    page: page,
                )
                // スター済みリポジトリの取得に成功
                // StarredRepoStoreの更新
                let newStarredRepos = response.starredRepos.map { StarredRepoTranslator.translate(from: $0) }
                try await starredRepoStore.addValues(newStarredRepos)
                
                // Viewのスター済みリポジトリのID一覧を更新
                let newIDs = newStarredRepos.map { $0.repoID }
                let combinedIDs = isLoadingMore ? (asyncStarredRepoIDs.values + newIDs) : newIDs
                withAnimation {
                    asyncStarredRepoIDs = .loaded(combinedIDs)
                }
                                
                nextLinkForFetchingStarredRepos = response.relationLink?.next
            } catch {
                // スター済みリポジトリの取得に失敗
                asyncStarredRepoIDs = .error(error, asyncStarredRepoIDs.values)
                self.error = error
            }
        }
    }
    
    /// スター済みリポジトリの取得
    func fetchStarredRepos() {
        // 「すでに検索中」の場合は何もしない
        if case .loading = asyncStarredRepoIDs {
            return
        }
        performFetchStarrredRepos(isLoadingMore: false, page: nil)
    }
    
    /// スター済みリポジトリの取得(追加読み込み)
    func fetchStarredReposMore() {
        // 他でダウンロード処理中であれば何もしない
        switch asyncStarredRepoIDs {
        case .loading, .loadingMore:
            return
        default:
            break
        }
        // 必要な情報のチェック
        guard let pageString = nextLinkForFetchingStarredRepos?.queryItems["page"],
              let page = Int(pageString)
        else {
            return
        }
        performFetchStarrredRepos(isLoadingMore: true, page: page)
    }
    
    /// ソート順が変更された
    func handleSortedChanged() {
        fetchStarredRepos()
    }
        
    func onAppear() {
        // 初回読み込み時のみ検索を実行
        if asyncStarredRepoIDs != .initial {
            return
        }
        fetchStarredRepos()
    }
}
