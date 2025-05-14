//
//  SearchReposViewState.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/09.
//

import SwiftUI
import IKEHGitHubAPIClient

@MainActor
@Observable
final class SearchReposViewState {

    // MARK: - Property(Public)
    
    /// 検索語句
    var searchText: String
    
    /// 検索結果のソート順
    var sortedBy: SearchReposSortedBy
    
    var error: Error?

    /// リポジトリの検索結果
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
        
    // MARK: - Property(Private)
    
    private var tokenStore: TokenStoreProtocol
    private var repoStore: RepoStoreProtocol
    private var searchReposSuggestionStore: SearchReposSuggestionStoreProtocol
    
    /// リポジトリの検索結果(このViewではIDのみを保持)
    private var asyncRepoIDs: AsyncValues<Repo.ID, Error>
    
    /// リポジトリ検索のページング情報
    private var searchReposRelationLink: RelationLink? // TODO: Linkだけでいい
    
    /// リポジトリ検索処理のTask
    private var searchReposTask: Task<(), Never>?
    
    // MARK: - LifeCycle
    
    // swiftlint:disable function_default_parameter_at_end
    init(
        searchText: String,
        sortedBy: SearchReposSortedBy,
        error: Error? = nil,
        tokenStore: TokenStoreProtocol,
        repoStore: RepoStoreProtocol,
        searchReposSuggestionStore: SearchReposSuggestionStoreProtocol,
        asyncRepoIDs: AsyncValues<Repo.ID, Error>,
        searchReposRelationLink: RelationLink? = nil,
        searchReposTask: Task<(), Never>? = nil
    ) {
        self.searchText = searchText
        self.sortedBy = sortedBy
        self.error = error
        self.tokenStore = tokenStore
        self.repoStore = repoStore
        self.searchReposSuggestionStore = searchReposSuggestionStore
        self.asyncRepoIDs = asyncRepoIDs
        self.searchReposRelationLink = searchReposRelationLink
        self.searchReposTask = searchReposTask
    }
    // swiftlint:enable function_default_parameter_at_end
    
    convenience init() {
        self.init(
            searchText: "Swift",
            sortedBy: .bestMatch,
            error: nil,
            tokenStore: TokenStore.shared,
            repoStore: RepoStore.shared,
            searchReposSuggestionStore: SearchReposSuggestionStore.shared,
            asyncRepoIDs: .initial,
            searchReposRelationLink: nil,
            searchReposTask: nil
        )
    }
}

extension SearchReposViewState {
    
    // TODO: 検索処理を一つのメソッドにまとめたい
    /// リポジトリの検索
    func searchRepos() {
        // 「すでに検索中」または「検索ワード未入力」の場合は何もしない
        if case .loading = asyncRepoIDs,
           searchText.isEmpty {
            return
        }
        
        searchReposSuggestionStore.addValue(searchText) // 検索履歴へ保存
        asyncRepoIDs = .loading(asyncRepoIDs.values)
        searchReposRelationLink = nil
        
        searchReposTask = Task {
            do {
                let response = try await repoStore.searchRepos(
                    searchText: searchText,
                    accessToken: tokenStore.accessToken,
                    sort: sortedBy.sort,
                    order: sortedBy.order,
                    perPage: 10,
                    page: nil
                )
                // 検索: 成功
                withAnimation {
                    asyncRepoIDs = .loaded(response.items.map { $0.id })
                }
                searchReposRelationLink = response.relationLink
            } catch {
                // 検索: ユーザがキャンセルした
                if Task.isCancelled {
                    if asyncRepos.values.isEmpty {
                        asyncRepoIDs = .initial
                    } else {
                        asyncRepoIDs = .loaded(asyncRepoIDs.values)
                    }
                } else {
                    // 検索: 失敗
                    asyncRepoIDs = .error(error, asyncRepoIDs.values)
                    self.error = error
                }
            }
        }
    }
    
    /// 検索結果の続きの読み込み
    func searchReposMore() {
        // 他でダウンロード処理中であればキャンセル
        switch asyncRepoIDs {
        case .loading, .loadingMore:
            return
        default:
            break
        }
        
        // リンク情報がない場合はキャンセル
        guard
            let nextLink = searchReposRelationLink?.next,
            let query = nextLink.queryItems["q"],
            let page = nextLink.queryItems["page"]
        else {
            return
        }
        
        // 検索の開始
        asyncRepoIDs = .loadingMore(asyncRepoIDs.values)
        searchReposTask = Task {
            do {
                let response = try await repoStore.searchRepos(
                    searchText: query,
                    accessToken: tokenStore.accessToken,
                    sort: sortedBy.sort,
                    order: sortedBy.order,
                    perPage: 10,
                    page: Int(page)
                )
                // 検索: 成功
                withAnimation {
                    asyncRepoIDs = .loaded(asyncRepoIDs.values + response.items.map { $0.id })
                }
                searchReposRelationLink = response.relationLink
            } catch {
                // 検索: ユーザがキャンセルした
                if Task.isCancelled {
                    asyncRepoIDs = .loaded(asyncRepoIDs.values)
                } else {
                    asyncRepoIDs = .error(error, asyncRepoIDs.values)
                    self.error = error
                }
            }
        }
    }
    
    /// ソート順が変更された際の動作
    func handleSortedChanged() {
        // 「検索済みではない」または「リンク情報がない」または「有効な検索結果がない」場合は何もしない
        guard case .loaded = asyncRepoIDs,
              let nextLink = searchReposRelationLink?.next, // TODO: 要検討
              let query = nextLink.queryItems["q"],
              !asyncRepos.values.isEmpty
        else {
            return
        }
        
        asyncRepoIDs = .loading(asyncRepoIDs.values)
        searchReposTask = Task {
            do {
                let response = try await repoStore.searchRepos(
                    searchText: query,
                    accessToken: tokenStore.accessToken,
                    sort: sortedBy.sort,
                    order: sortedBy.order,
                    perPage: 10,
                    page: nil,
                )
                // 検索: 成功
                withAnimation {
                    asyncRepoIDs = .loaded(response.items.map { $0.id })
                }
                searchReposRelationLink = response.relationLink
            } catch {
                // 検索: ユーザがキャンセルした
                if Task.isCancelled {
                    asyncRepoIDs = .loaded(asyncRepoIDs.values)
                } else {
                    asyncRepoIDs = .error(error, asyncRepoIDs.values)
                    self.error = error
                }
            }
        }
    }
    
    /// 現在の検索の中断
    func cancelSearchRepos() {
        searchReposTask?.cancel()
        searchReposTask = nil
    }
}
