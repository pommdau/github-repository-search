//
//  SearchScreenViewState.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/15.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class SearchScreenViewState {
    
    // MARK: - Property
    
    // MARK: 検索条件
    
    var searchText: String = "Swift"
    var sortedBy: SearchReposSortedBy = .bestMatch
                
    // MARK: 検索結果
    
    private var asyncRepoIDs: AsyncValues<Repo.ID, Error> = .initial
    
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
    
    private var relationLink: RelationLink?
    var error: Error?
    
    // MARK: その他
    
    private(set) var searchTask: Task<(), Never>?
        
    let gitHubAPIClient: GitHubAPIClient
    let repoStore: RepoStore
    let loginUserStore: LoginUserStore
    let searchSuggestionStore: SearchSuggestionStore
    
    // MARK: - LifeCycle
    
    init(gitHubAPIClient: GitHubAPIClient = .shared,
         repoStore: RepoStore = .shared,
         loginUserStore: LoginUserStore = .shared,
         searchSuggestionStore: SearchSuggestionStore = .shared
    ) {
        self.gitHubAPIClient = gitHubAPIClient
        self.repoStore = repoStore
        self.loginUserStore = loginUserStore
        self.searchSuggestionStore = searchSuggestionStore
    }
}

// MARK: - Search

extension SearchScreenViewState {
    
    /// 通常の語句検索
    func handleSearch() {
        // すでに検索中であれば何もしない
        if case .loading = asyncRepos {
            return
        }
        
        // 検索ワード未入力の場合
        if searchText.isEmpty {
            return
        }
        searchSuggestionStore.addHistory(searchText) // 検索履歴の保存
        
        asyncRepoIDs = .loading(asyncRepoIDs.values)
        relationLink = nil
        
        searchTask = Task {
            do {
                // 検索: 成功
                let response = try await gitHubAPIClient.searchRepos(searchText: searchText, sort: sortedBy.sort, order: sortedBy.order)
                try await repoStore.addValues(response.items, updateStarred: false)
                withAnimation {
                    asyncRepoIDs = .loaded(response.items.map { $0.id })
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
    
    /// 検索結果の続きの読み込み
    func handleSearchMore() {
        
        // 他でダウンロード処理中であればキャンセル
        switch asyncRepos {
        case .loading, .loadingMore:
            return
        default:
            break
        }
        
        // リンク情報がなければ何もしない
        guard
            let nextLink = relationLink?.next,
            let query = nextLink.queryItems["q"],
            let page = nextLink.queryItems["page"]
        else {
            return
        }
        
        // 検索開始
        asyncRepoIDs = .loadingMore(asyncRepoIDs.values)
        searchTask = Task {
            do {
                // 検索に成功
                let response = try await gitHubAPIClient.searchRepos(searchText: query, page: Int(page), sort: sortedBy.sort, order: sortedBy.order)
                try await repoStore.addValues(response.items, updateStarred: false)
                withAnimation {
                    asyncRepoIDs = .loaded(asyncRepoIDs.values + response.items.map { $0.id })
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
        // リンク情報がなければ何もしない(TODO: 見直せるかも)
        guard case .loaded = asyncRepos,
              !asyncRepos.values.isEmpty,
              let nextLink = relationLink?.next,
              let query = nextLink.queryItems["q"]
        else {
            return
        }
        
        asyncRepoIDs = .loading(asyncRepoIDs.values)
        searchTask = Task {
            do {
                let response = try await gitHubAPIClient.searchRepos(searchText: query, sort: sortedBy.sort, order: sortedBy.order)
                try await repoStore.addValues(response.items, updateStarred: false)
                withAnimation {
                    asyncRepoIDs = .loaded(response.items.map { $0.id })
                }
                relationLink = response.relationLink
            } catch {
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

// MARK: - Cancel Search

extension SearchScreenViewState {
    /// 現在の検索の中断
    func cancelSearch() {
        searchTask?.cancel()
        searchTask = nil
    }
}
