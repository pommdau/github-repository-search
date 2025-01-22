//
//  SearchScreen.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/14.
//

import SwiftUI

struct SearchScreen: View {
    
    @State private var viewState = SearchScreenViewState()
    
    var body: some View {
        NavigationStack {
            searchTypePicker()
            SearchResultView(
                asyncRepos: viewState.asyncRepos,
                cancelSearching: {
                    viewState.cancelSearching()
                },
                bottomCellOnAppear: { _ in
                    // 一番下のセルが表示された場合
                    viewState.handleSearchMore()
                })
        }
        .searchable(text: $viewState.searchText, prompt: "Enter Keyword")
        .onSubmit(of: .search) {
            viewState.handleSearchText()
        }
        .onAppear() {
        }
    }
    
    @ViewBuilder
    private func searchTypePicker() -> some View {
        HStack(spacing: 0) {
            Text("Search: ")
                .padding(.trailing, -12)
            Picker("SearchType", selection: $viewState.searchType) {
                ForEach(SearchType.allCases) { type in
                    /// 選択項目の一覧
                    Text(type.title).tag(type)
                }
            }
            .accentColor(.primary)
            .pickerStyle(.menu)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 18)
    }
}

#Preview {
    SearchScreen()
}
