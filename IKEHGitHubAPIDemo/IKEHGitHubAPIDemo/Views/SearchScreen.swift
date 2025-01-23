//
//  SearchScreen.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/14.
//

import SwiftUI

struct SearchScreen: View {
    
    @State private var viewState = SearchScreenViewState()
    
    @State private var selectionColor: Color = .red

    var body: some View {
        NavigationStack {
//            searchTypePicker()
            SearchResultView(
                asyncRepos: viewState.asyncRepos,
                cancelSearching: {
                    viewState.cancelSearching()
                },
                bottomCellOnAppear: { _ in
                    // 一番下のセルが表示された場合
                    viewState.handleSearchMore()
                })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("SearchType", selection: $viewState.searchType) {
                            ForEach(SearchType.allCases) { type in
                                /// 選択項目の一覧
                                Text(type.title).tag(type)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
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
            Text("Sort by:")
                .padding()
            Picker("SearchType", selection: $viewState.searchType) {
                ForEach(SearchType.allCases) { type in
                    /// 選択項目の一覧
                    Text(type.title).tag(type)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
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
