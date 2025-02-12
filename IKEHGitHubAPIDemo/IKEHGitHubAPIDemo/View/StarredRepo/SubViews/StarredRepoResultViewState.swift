//
//  StarredReposViewState.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/02.
//

import SwiftUI

@MainActor @Observable
final class StarredRepoResultViewState {
    
    // MARK: - Property
    
    // MARK: Property
    
    let loginUserStore: LoginUserStore
    let githubAPIClient: GitHubAPIClient
    let repoStore: RepoStore
    var error: Error?
    var sortedBy: GitHubAPIRequest.StarredReposRequest.SortBy = .recentryStarred

    private(set) var asyncRepoIDs: AsyncValues<Repo.ID, Error> = .initial
    private var fetchStarredReposTask: Task<(), Never>?
    private var relationLink: RelationLink?
    
    // MARK: Computed Property
    
    var loginUser: LoginUser? {
        loginUserStore.value
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
        githubAPIClient: GitHubAPIClient = .shared,
        repoStore: RepoStore = .shared
    ) {
        self.loginUserStore = loginUserStore
        self.githubAPIClient = githubAPIClient
        self.repoStore = repoStore
    }
}

// MARK: - Fetch Starred Repository

extension StarredRepoResultViewState {
    
    func fetchStarredRepos(userName: String) {
        fetchStarredReposTask = Task {
            do {
                // 検索: 成功
                let response = try await githubAPIClient.fetchStarredRepos(userName: userName, sortedBy: sortedBy)
                try await repoStore.addValues(response.repos)
                withAnimation {
                    asyncRepoIDs = .loaded(response.repos.map { $0.id })
                }
                relationLink = response.relationLink
            } catch {
                // 検索: 失敗
                if Task.isCancelled {
                    if asyncRepos.values.isEmpty {
                        asyncRepoIDs = .initial
                    } else {
                        asyncRepoIDs = .loaded(asyncRepoIDs.values)
                    }
                } else {
                    asyncRepoIDs = .error(error, asyncRepoIDs.values)
                    self.error = error
                }
            }
        }
    }
    
//    func fetchStarredReposMore() {
//
//    }
    
}

// MARK: - Actions

extension StarredRepoResultViewState {
    func handleLogInButtonTapped() {
        Task {
            do {
                try await githubAPIClient.openLoginPageInBrowser()
            } catch {
                self.error = error
            }
        }
    }
    
    func handleFetchingStarredRepos() {
        // すでに検索中であれば何もしない
        if case .loading = asyncRepoIDs {
            return
        }
        guard let userName = loginUser?.login else {
            return
        }
        asyncRepoIDs = .loading(asyncRepoIDs.values)
        relationLink = nil
        
        fetchStarredRepos(userName: userName)
    }
    
    /// 検索結果の続きの読み込み
    func fetchStarredReposMore() {
        
        // 他でダウンロード処理中であればキャンセル
        switch asyncRepos {
        case .loading, .loadingMore:
            return
        default:
            break
        }
        
        guard
            let userName = loginUser?.login,
            let nextLink = relationLink?.next // リンク情報がなければ何もしない
        else {
            return
        }
        
        // 検索開始
        asyncRepoIDs = .loadingMore(asyncRepoIDs.values)
        fetchStarredReposTask = Task {
            do {
                // 検索に成功
                let response = try await githubAPIClient.fetchStarredRepos(userName: userName, sortedBy: sortedBy, page: nextLink.page)
                try await repoStore.addValues(response.repos)
                withAnimation {
                    asyncRepoIDs = .loaded(asyncRepoIDs.values + response.repos.map { $0.id })
                }
                relationLink = response.relationLink
            } catch {
                // 検索に失敗
                if Task.isCancelled {
                    asyncRepoIDs = .loaded(asyncRepoIDs.values)
                } else {
                    asyncRepoIDs = .error(error, asyncRepoIDs.values)
                    self.error = error
                }
            }
        }
    }
    
    /// ソート順が変更された際の再検索
    func handleSortedByChanged() {
        
        // 検索済み以外は何もしない
        // 有効な検索結果がなければ何もしない
        // リンク情報がなければ何もしない(=検索結果がこれ以上無いので並び替えだけでOK)(TODO: 見直せるかも)
        guard case .loaded = asyncRepos,
              !asyncRepoIDs.values.isEmpty,
              let _ = relationLink?.next,
              let userName = loginUser?.login
        else {
            return
        }
        
        asyncRepoIDs = .loading(asyncRepoIDs.values)
        
        fetchStarredRepos(userName: userName)
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
        // 前提処理
        guard let userName = loginUser?.login else {
            return
        }
        
        // 初回読み込み時のみ実行
        if asyncRepoIDs != .initial {
            return
        }
        
        // 読込中に更新
        asyncRepoIDs = .loading(asyncRepoIDs.values)
        relationLink = nil
        
        // スター済みリポジトリを取得
        fetchStarredReposTask = Task {
            do {
                // 検索: 成功
                let response = try await githubAPIClient.fetchStarredRepos(userName: userName, sortedBy: sortedBy)
                try await repoStore.addValues(response.repos)
                withAnimation {
                    asyncRepoIDs = .loaded(response.repos.map { $0.id })
                }
                relationLink = response.relationLink
            } catch {
                // 検索: 失敗
                if Task.isCancelled {
                    if asyncRepos.values.isEmpty {
                        asyncRepoIDs = .initial
                    } else {
                        asyncRepoIDs = .loaded(asyncRepoIDs.values)
                    }
                } else {
                    asyncRepoIDs = .error(error, asyncRepoIDs.values)
                    self.error = error
                }
            }
        }
    }
}


////
////  StarredRepoListView.swift
////  IKEHGitHubAPIDemo
////
////  Created by HIROKI IKEUCHI on 2025/02/02.
////
//
//import SwiftUI
//
//@MainActor @Observable
//final class StarredRepoResultViewState {
//    
//    // MARK: - Property
//    
//    let asyncRepos: AsyncValues<Repo, Error>
//    
//    var showNoResultView: Bool {
//        // 検索結果が0であることが前提
//        if !asyncRepos.values.isEmpty {
//            return false
//        }
//        
//        // 検索済み or エラーのとき
//        switch asyncRepos {
//        case .loaded, .error:
//            return true
//        default:
//            return false
//        }
//    }
//    
//    // MARK: - LifeCycle
//    
//    init(asyncRepos: AsyncValues<Repo, Error>) {
//        self.asyncRepos = asyncRepos
//    }
//}





