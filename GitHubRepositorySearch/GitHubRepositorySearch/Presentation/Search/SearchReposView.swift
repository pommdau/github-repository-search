//
//  SearchReposView.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import SwiftUI
import IKEHGitHubAPIClient

@MainActor
@Observable
final class SearchReposViewState {

    // MARK: - Property(Public)
    
    var searchText: String
    var sortedBy: SearchReposSortedBy
    var error: Error?

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
    private var asyncRepoIDs: AsyncValues<Repo.ID, Error>
    private var searchReposRelationLink: RelationLink?
    private var searchReposTask: Task<(), Never>?
    
    // MARK: - LifeCycle
    
    // swiftlint:disable function_default_parameter_at_end
    init(
        searchText: String,
        sortedBy: SearchReposSortedBy,
        error: Error? = nil,
        tokenStore: TokenStore,
        repoStore: RepoStoreProtocol,
        asyncRepoIDs: AsyncValues<Repo.ID, Error>,
        searchReposRelationLink: RelationLink? = nil,
        searchReposTask: Task<(), Never>? = nil
    ) {
        self.searchText = searchText
        self.sortedBy = sortedBy
        self.error = error
        self.tokenStore = tokenStore
        self.repoStore = repoStore
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
            asyncRepoIDs: .initial,
            searchReposRelationLink: nil,
            searchReposTask: nil
        )
    }
}

extension SearchReposViewState {
    
    func searchRepos() {
        
        // 「すでに検索中」または「検索ワード未入力」の場合は何もしない
        if case .loading = asyncRepoIDs,
           searchText.isEmpty {
            return
        }
        
        //        searchSuggestionStore.addHistory(searchText) // 検索履歴へ保存
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
    
    func searchReposMore() {
    }
    
    /// ソート順が変更された際の動作
    func handleSortedChanged() {
    }
    
    /// 現在の検索の中断
    func cancelSearchRepos() {
        searchReposTask?.cancel()
        searchReposTask = nil
    }
}

struct SearchReposView: View {
    
    @State private var state: SearchReposViewState = .init()
    
    var body: some View {
        NavigationStack {
            SearchResultView(
                asyncRepos: state.asyncRepos,
                searchText: state.searchText,
                cancelSearching: {
                    state.cancelSearchRepos()
                },
                bottomCellOnAppear: { _ in }
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    sortedByToolbarItemContent()
                }
            }
        }
        .searchable(text: $state.searchText, prompt: "Enter Keyword")
        .searchSuggestions {
//            SearchSuggestionView()
        }
        .onSubmit(of: .search) {
            state.searchRepos()
        }
        .errorAlert(error: $state.error)
    }
    
    // MARK: - UI Parts
    
    @ViewBuilder
    private func sortedByToolbarItemContent() -> some View {
        Menu {
            Picker("Sorted By", selection: $state.sortedBy) {
                ForEach(SearchReposSortedBy.allCases) { type in
                    /// 選択項目の一覧
                    Text(type.title).tag(type)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onChange(of: state.sortedBy) { _, _ in
                state.handleSortedChanged()
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .accessibilityLabel(Text("SortedBy icon"))
        }
    }
}

// MARK: - Preview

#Preview {
    SearchReposView()
}
