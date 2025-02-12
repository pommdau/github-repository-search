//
//  SearchScreen.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/14.
//

import SwiftUI

struct SearchScreen: View {
    
    @State private var state = SearchScreenViewState()

    var body: some View {
        NavigationStack {
//            searchTypePicker()
            SearchResultView(
                asyncRepos: state.asyncRepos,
                cancelSearching: {
                    state.cancelSearch()
                },
                bottomCellOnAppear: { _ in
                    // 一番下のセルが表示された場合
                    state.handleSearchMore()
                }
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    sortedByToolbarItemContent()
                }
            }
        }
        .searchable(text: $state.searchText, prompt: "Enter Keyword")
        .onSubmit(of: .search) {
            state.handleSearch()
        }
        .onAppear() {
        }
        .errorAlert(error: $state.error)
    }
    
    @ViewBuilder
    private func sortedByToolbarItemContent() -> some View {
        Menu {
            Picker("Sorted By", selection: $state.sortedBy) {
                ForEach(GitHubAPIRequest.SearchReposRequest.SortBy.allCases) { type in
                    /// 選択項目の一覧
                    Text(type.title).tag(type)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onChange(of: state.sortedBy) { _, _ in
                state.handleSortedByChanged()
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
    }
}

#Preview {
    SearchScreen()
}
