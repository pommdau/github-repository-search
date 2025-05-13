//
//  SearchReposView.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import SwiftUI

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
                bottomCellOnAppear: { _ in
                    state.searchReposMore()
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
            state.searchRepos()
        }
        .errorAlert(error: $state.error)
    }
    
    // MARK: - UI Components
    
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
