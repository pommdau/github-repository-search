//
//  SearchScreenViewState.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/15.
//

import Foundation
import SwiftUI

@MainActor @Observable
final class SearchScreenViewState {
    
    // MARK: - Property
    
    // MARK: 検索条件
    
    var searchText: String = "Swift"
    var sortedBy: GitHubAPIRequest.SearchReposRequest.SortBy = .bestMatch
    
    // MARK: 検索結果
    
    private(set) var asyncRepos: AsyncValues<Repo, Error> = .initial
    private var relationLink: RelationLink?
    
    // エラー表示
    var alertError: Error?
    var showAlert = false
    
    // MARK: その他
    
    private(set) var searchTask: Task<(), Never>?
        
    let gitHubAPIClient: GitHubAPIClient
    let loginUserStore: LoginUserStore
    
    // MARK: - LifeCycle
    
    init(gitHubAPIClient: GitHubAPIClient = .shared,
         loginUserStore: LoginUserStore = .shared) {
        self.gitHubAPIClient = gitHubAPIClient
        self.loginUserStore = loginUserStore
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
        
        asyncRepos = .loading(asyncRepos.values)
        relationLink = nil
        
        searchTask = Task {
            do {
                // 検索に成功
                let response = try await gitHubAPIClient.searchRepos(searchText: searchText, sortedBy: sortedBy)
                withAnimation {
                    asyncRepos = .loaded(response.items)
                }
                relationLink = response.relationLink
            } catch {
                // 検索に失敗
                if Task.isCancelled {
                    if asyncRepos.values.isEmpty {
                        asyncRepos = .initial
                    } else {
                        asyncRepos = .loaded(asyncRepos.values)
                    }
                } else {
                    asyncRepos = .error(error, asyncRepos.values)
                    print(error.localizedDescription)
                    alertError = error
                    showAlert = true
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
        guard let nextLink = relationLink?.next else {
            return
        }
        
        // 検索開始
        asyncRepos = .loadingMore(asyncRepos.values)
        searchTask = Task {
            do {
                // 検索に成功
                let response = try await gitHubAPIClient.searchRepos(searchText: nextLink.searchText, page: nextLink.page)
                withAnimation {
                    asyncRepos = .loaded(asyncRepos.values + response.items)
                }
                relationLink = response.relationLink
            } catch {
                // 検索に失敗
                if Task.isCancelled {
                    asyncRepos = .loaded(asyncRepos.values)
                } else {
                    asyncRepos = .error(error, asyncRepos.values)
                    print(error.localizedDescription)
                    alertError = error
                    showAlert = true
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
              let nextLink = relationLink?.next
        else {
            return
        }
        
        asyncRepos = .loading(asyncRepos.values)
        searchTask = Task {
            do {
                let response = try await gitHubAPIClient.searchRepos(searchText: nextLink.searchText, sortedBy: sortedBy)
                withAnimation {
                    asyncRepos = .loaded(response.items)
                }
                relationLink = response.relationLink
            } catch {
                if Task.isCancelled {
                    if asyncRepos.values.isEmpty {
                        asyncRepos = .initial
                    } else {
                        asyncRepos = .loaded(asyncRepos.values)
                    }
                } else {
                    asyncRepos = .error(error, asyncRepos.values)
                    print(error.localizedDescription)
                    alertError = error
                    showAlert = true
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
