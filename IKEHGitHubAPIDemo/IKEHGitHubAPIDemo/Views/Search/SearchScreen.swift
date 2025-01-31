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
        }
        .searchable(text: $state.searchText, prompt: "Enter Keyword")
        .onSubmit(of: .search) {
            state.handleSearch()
        }
        .onAppear() {
        }
        .alert("エラー", isPresented: $state.showAlert) {
            Button("OK") { }
        } message: {
            Text(state.alertError?.localizedDescription ?? "(不明なエラー)")
        }
    }
    
    @ViewBuilder
    private func searchTypePicker() -> some View {
        HStack(spacing: 0) {
            Text("Sort by:")
                .padding()
//            Picker("SearchType", selection: $viewState.searchType) {
//                ForEach(GitHubAPIRequest.NewSearchRequest.SortBy.allCases) { sortedBy in
//                    /// 選択項目の一覧
//                    Text(sortedBy.title).tag(sortedBy)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
//            }
            .accentColor(.primary)
            .pickerStyle(.menu)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.trailing, 18)
    }
}

#Preview {
    SearchScreen()
}
