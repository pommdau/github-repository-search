//
//  SearchReposView.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import SwiftUI
import IKEHGitHubAPIClient
import Shimmer

struct SearchReposView: View {
    
    // MARK: - Property
        
    @State private var state: SearchReposViewState = .init()
    
    // MARK: - View
    
    var body: some View {
        NavigationStack {
            Content(
                asyncRepos: state.asyncRepos,
                searchText: state.searchText,
                cancelSearching: {
                    state.handleCancelSearchRepos()
                },
                bottomCellOnAppear: { _ in
                    state.handleSearchReposMore()
                }
            )
            .navigationTitle("Search Repositories")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    sortedByToolbarItemContent()
                }
            }
        }
        .searchable(text: $state.searchText, prompt: "Enter Keyword")
        .searchSuggestions {
            SearchReposSuggestionView()
        }
        .onSubmit(of: .search) {
            state.handleSearchRepos()
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
                state.handleSearchReposSortedChanged()
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .accessibilityLabel(Text("SortedBy icon"))
        }
    }
}

// MARK: - Content

extension SearchReposView {

    struct Content: View {
        
        // MARK: - Property
        
        // isSearchingは.searchableと同じViewで使用できないことに注意
        @Environment(\.isSearching)
        private var isSearching: Bool
        
        @Namespace private var namespace
                
        let asyncRepos: AsyncValues<Repo, Error>
        var searchText: String = ""
        var cancelSearching: () -> Void = {}
        var bottomCellOnAppear: (Repo.ID) -> Void = { _ in }
        
        // MARK: - Computed Property
        
        /// 検索結果がないラベルの表示フラグ
        var showNoResultLabel: Bool {
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
        // MARK: - View
        
        var body: some View {
            AsyncValuesList(asyncValues: asyncRepos) {
                initialView()
            } loadingView: {
                loadingView()
            } dataView: { repos in
                dataView(repos: repos)
            } noResultView: {
                noResultView()
            }
            .scrollContentBackground(.hidden)
            .onChange(of: isSearching) {
                if !isSearching {
                    // 検索がキャンセルされた場合
                    cancelSearching()
                }
            }
        }
        
        // MARK: - UI Parts
        
        @ViewBuilder
        private func initialView() -> some View {
            ContentUnavailableView("Search GitHub Repositories!", systemImage: "magnifyingglass")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        
        @ViewBuilder
        private func loadingView() -> some View {
            Group {
                ForEach(0..<5, id: \.self) { _ in
                    RepoCell(repo: Repo.Mock.skeltonRepoCell)
                        .redacted(reason: .placeholder)
                        .shimmering()
                }
            }
            .id(UUID())
        }
        
        @ViewBuilder
        private func dataView(repos: [Repo]) -> some View {
            ForEach(repos) { repo in
                NavigationLink {
                    RepoDetailsView(repoID: repo.id)
                        .navigationTransition(.zoom(sourceID: "\(repo.id)", in: namespace))
                } label: {
                    RepoCell(repo: repo)
                        .padding(.vertical, 4)
                        .matchedTransitionSource(id: "\(repo.id)", in: namespace)
                        .onAppear {
                            // 一番したのセルが表示されたことを検出する
                            guard let lastRepo = asyncRepos.values.last else {
                                return
                            }
                            if lastRepo.id == repo.id {
                                bottomCellOnAppear(repo.id)
                            }
                        }
                }
            }
        }
        
        @ViewBuilder
        private func noResultView() -> some View {
            ContentUnavailableView.search(text: searchText)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

// MARK: - Preview

#Preview("View全体(初期状態)") {
    SearchReposView()
}

// MARK: - Preview Content

#Preview("初期状態") {
    NavigationStack {
        SearchReposView.Content(
            asyncRepos: .initial
        )
    }
}

#Preview("検索中") {
    NavigationStack {
        SearchReposView.Content(
            asyncRepos: .loading([])
        )
    }
}

#Preview("検索済み") {
    NavigationStack {
        SearchReposView.Content(
            asyncRepos: .loaded(Repo.Mock.random(count: 10))
        )
    }
}

#Preview("検索済み(結果なし)") {
    NavigationStack {
        SearchReposView.Content(
            asyncRepos: .loaded([])
        )
    }
}

#Preview("追加の検索中") {
    NavigationStack {
        SearchReposView.Content(
            asyncRepos: .loadingMore(Repo.Mock.random(count: 3))
        )
    }
}

#Preview("エラー(検索結果あり)") {
    NavigationStack {
        SearchReposView.Content(
            asyncRepos: .error(
                MessageError(description: "sample error"),
                Repo.Mock.random(count: 3)
            )
        )
    }
}

#Preview("エラー(検索結果なし)") {
    NavigationStack {
        SearchReposView.Content(
            asyncRepos: .error(MessageError(description: "sample error"), [])
        )
    }
}
