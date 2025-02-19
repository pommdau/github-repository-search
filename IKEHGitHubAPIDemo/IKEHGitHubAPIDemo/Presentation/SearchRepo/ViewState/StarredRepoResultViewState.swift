//
//  StarredReposViewState.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/02.
//

import SwiftUI

@MainActor
@Observable
final class StarredRepoResultViewState {
    
    // MARK: - Property(Private)
    
    private let loginUserStore: LoginUserStore
    private let repoStore: RepoStore
    private let githubAPIClient: GitHubAPIClient
    
    private var fetchStarredReposTask: Task<(), Never>?
    private var asyncRepoIDs: AsyncValues<Repo.ID, Error> = .initial
    private var relationLink: RelationLink?
    
    // MARK: - Property(Public)
    
    var error: Error?
    var sortedBy: GitHubAPIRequest.StarredReposRequest.SortBy = .recentlyStarred
        
    var loginUser: LoginUser? {
        loginUserStore.value
    }
    
    var loginUserName: String? {
        loginUser?.login
    }
        
    var asyncRepos: AsyncValues<Repo, Error> {
        let repos = asyncRepoIDs.values.compactMap { repoStore.valuesDic[$0] }
        switch asyncRepoIDs {
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
        
    var isFetchingRepos: Bool {
        switch asyncRepoIDs {
        case .loading, .loadingMore:
            return true
        default:
            return false
        }
    }
    
    /// 検索結果が見つからなかった旨のViewを表示するかどうか
    var showNoResultView: Bool {
        // 検索結果が0であることが前提
        if !asyncRepos.values.isEmpty {
            return false
        }
        
        // 検索済み or エラーのとき
        switch asyncRepos {
        case .loaded, .error:
            return true
        default:
            return false
        }
    }

    // MARK: - LifeCycle
    
    init(
        loginUserStore: LoginUserStore = .shared,
        repoStore: RepoStore = .shared,
        githubAPIClient: GitHubAPIClient = .shared
    ) {
        self.loginUserStore = loginUserStore
        self.repoStore = repoStore
        self.githubAPIClient = githubAPIClient
    }
}

// MARK: - Actions

// MARK: - Fetch Starred Repository

extension StarredRepoResultViewState {
    
    func fetchStarredRepos(page: Int? = nil, isLoadingMore: Bool = false) {
        guard let loginUserName else {
            return
        }
//        fetchStarredReposTask?.cancel() // 既に実行中のtaskがあれば終了
//        await fetchStarredReposTask?.cancel()
                                            
        // 状態の変更
        if isLoadingMore {
            asyncRepoIDs = .loadingMore(asyncRepoIDs.values)
        } else {
            asyncRepoIDs = .loading(asyncRepoIDs.values)
        }
        
        relationLink = nil // TODO 見直し
                                        
        fetchStarredReposTask = Task {
            try? await Task.sleep(for: .seconds(1))
            do {
                // 検索の実行
                let response = try await githubAPIClient.fetchStarredRepos(userName: loginUserName, sortedBy: sortedBy, page: page)

                // 検索に成功
                try await repoStore.addValues(response.repos) // Storeに検索結果を保存
                // ViewStateに検索結果を保存
                relationLink = response.relationLink
                withAnimation {
                    if isLoadingMore {
                        asyncRepoIDs = .loaded(asyncRepoIDs.values + response.repos.map { $0.id })
                    } else {
                        asyncRepoIDs = .loaded(response.repos.map { $0.id })
                    }
                }
                
            } catch {
                // 検索に失敗
                if Task.isCancelled {
                    // 検索が明示的にキャンセルされた
                    if asyncRepos.values.isEmpty {
                        asyncRepoIDs = .initial
                    } else {
                        asyncRepoIDs = .loaded(asyncRepoIDs.values)
                    }
                } else {
                    // エラーが発生した
                    asyncRepoIDs = .error(error, asyncRepoIDs.values)
                    self.error = error
                }
            }
        }
    }
}

// MARK: - Actions

extension StarredRepoResultViewState {
        
    func handleFetchingStarredRepos() {
        // すでに検索中であれば何もしない
        if case .loading = asyncRepoIDs {
            return
        }
        fetchStarredRepos()
    }
    
    /// 検索結果の続きの読み込み
    func handleFetchStarredReposMore() {
        // すでに検索中であれば何もしない
        switch asyncRepos {
        case .loading, .loadingMore:
            return
        default:
            break
        }
        
        // リンク情報がなければ何もしない
        guard let nextLink = relationLink?.next else {
            return
        }
        
        // 検索開始
        asyncRepoIDs = .loadingMore(asyncRepoIDs.values)
        fetchStarredRepos(page: nextLink.page, isLoadingMore: true)
    }
    
    /// Pull to refresh時の処理
    func handlePullToRefresh() async {
        // 検索済み以外は何もしない
        guard case .loaded = asyncRepos else {
            return
        }
        fetchStarredRepos()
    }
    
    /// ソート順が変更された際の再検索
    func handleSortedByChanged() {
        guard case .loaded = asyncRepos else {
            return
        }
        fetchStarredRepos()
    }
    
    func onAppearRepoCell(id: Repo.ID) {
        guard let lastRepoID = asyncRepoIDs.values.last else {
            return
        }
        // Listの最後のセルが表示された場合
        if lastRepoID == id {
//            bottomCellOnAppear(repo.id)
            print("最終セルが選択されました")
        }
    }
        
    func onAppear() {
        // 初回読み込み時のみ実行
        if asyncRepoIDs != .initial {
            return
        }
        fetchStarredRepos()
    }
}
