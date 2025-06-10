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

    // MARK: - Public Property
    
    /// 検索語句
    var searchText: String
    
    /// 最後に検索した検索語句
    /// - Note: searchTextはTextFieldで直接バインドされるので、検索結果のソート順が変更された場合に再検索するために保持
    var lastSearchText: String?
        
    /// 検索結果のソート順
    var sortedBy: SearchReposSortedBy {
        didSet {
            UserDefaults.standard.set(sortedBy.rawValue, forKey: UserDefaults.Key.SearchReposViewState.sortedBy)
        }
    }
    
    /// リポジトリ検索のページング情報
    var nextLink: RelationLink.Link?
    /// リポジトリ検索処理のTask
    var searchReposTask: Task<(), Never>?
    
    var error: Error?
    
    var searchReposSuggestionStore: SearchReposSuggestionStoreProtocol
            
    // MARK: - Private Property
    
    private var tokenStore: TokenStoreProtocol
    private var repoStore: RepoStoreProtocol
       
    /// リポジトリの検索結果(このViewではIDのみを保持)
    private var asyncRepoIDs: AsyncValues<Repo.ID, Error>
    
    // MARK: Computed Property
    
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
    
    // MARK: - LifeCycle
    
    init(
        searchText: String = "",
        tokenStore: TokenStoreProtocol = TokenStore.shared,
        repoStore: RepoStoreProtocol = RepoStore.shared,
        searchReposSuggestionStore: SearchReposSuggestionStoreProtocol = SearchReposSuggestionStore.shared,
        asyncRepoIDs: AsyncValues<Repo.ID, Error> = .initial,
        nextLink: RelationLink.Link? = nil
    ) {
        self.searchText = searchText
        // ソート順が保存されている場合はそれを使用し、なければデフォルトのソート順を使用
        if let rawValue = UserDefaults.standard.string(forKey: UserDefaults.Key.SearchReposViewState.sortedBy),
           let sortedBy = SearchReposSortedBy(rawValue: rawValue) {
            self.sortedBy = sortedBy
        } else {
            self.sortedBy = .bestMatch
        }
        self.tokenStore = tokenStore
        self.repoStore = repoStore
        self.searchReposSuggestionStore = searchReposSuggestionStore
        self.asyncRepoIDs = asyncRepoIDs
        self.nextLink = nextLink
    }
}

// MARK: - リポジトリの検索

extension SearchReposViewState {
    
    /// リポジトリ検索の一連の処理の実行
    func performSearchRepos(query: String, page: Int? = nil, isLoadingMore: Bool = false) {
        // 検索を実行するかの確認
        if !shouldSearchRepos(query: query) {
            return
        }
        // 状態の更新
        updateStatusBeforeSearchRepos(query: query, isLoadingMore: isLoadingMore)
        searchReposTask = Task {
            do {
                let response = try await repoStore.searchRepos(
                    searchText: query,
                    accessToken: tokenStore.accessToken,
                    sort: sortedBy.sort,
                    order: sortedBy.order,
                    perPage: 10,
                    page: page
                )
                // 状態の更新(成功時)
                updateStatusAfterSearchRepos(with: response, query: query, isLoadingMore: isLoadingMore)
            } catch {
                // 状態の更新(失敗時)
                updateStatusAfterSearchRepos(with: error)
            }
        }        
    }
        
    private func shouldSearchRepos(query: String) -> Bool {
        // 検索語句が空の場合は検索を行わない
        if query.isEmpty {
            return false
        }
        // すでに検索中の状態である場合は検索を行わない
        switch asyncRepoIDs {
        case .initial, .loaded, .error:
            return true
        case .loading, .loadingMore:
            return false
        }
    }
    
    /// 検索前の状態の更新
    private func updateStatusBeforeSearchRepos(query: String, isLoadingMore: Bool) {
        searchReposSuggestionStore.addValue(query) // 検索履歴へ保存
        asyncRepoIDs = isLoadingMore ? .loadingMore(asyncRepoIDs.values) : .loading(asyncRepoIDs.values)
    }
    
    // 検索後の状態の更新(成功時)
    private func updateStatusAfterSearchRepos(with response: SearchResponse<Repo>, query: String, isLoadingMore: Bool) {
        let newRepoIDs = response.items.map { $0.id }
        // 追加読み込みの場合は既存のIDに追加する
        let combinedRepoIDs = isLoadingMore ? (asyncRepoIDs.values + newRepoIDs) : newRepoIDs
        withAnimation {
            asyncRepoIDs = .loaded(combinedRepoIDs)
        }
        lastSearchText = query
        nextLink = response.relationLink?.next
    }
    
    /// 検索後の状態の更新(失敗時)
    private func updateStatusAfterSearchRepos(with error: Error) {
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

// MARK: - Actions

extension SearchReposViewState {
    
    /// リポジトリの検索
    func handleSearchRepos() {
        performSearchRepos(query: searchText)
    }
    
    /// リポジトリの検索結果の続きの読み込み
    func handleSearchReposMore() {
        // 必要な情報の確認
        guard
            let nextLink,
            let query = nextLink.queryItems["q"],
            let pageString = nextLink.queryItems["page"],
            let page = Int(pageString)
        else {
            return
        }
        performSearchRepos(query: query, page: page, isLoadingMore: true)
    }
    
    /// ソート順が変更された
    func handleSearchReposSortedChanged() {
        // 最後に検索した検索語句を使用して再検索
        guard let query = lastSearchText else {
            return
        }
        performSearchRepos(query: query)
    }
    
    /// リポジトリ検索の中断
    func handleCancelSearchRepos() {
        searchReposTask?.cancel()
        searchReposTask = nil
    }
}
