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
        .searchable(text: $viewState.keyword, prompt: "Enter Keyword")
        .onSubmit(of: .search) {
            viewState.handleSearchKeyword()
        }
        .onAppear {
            Task {
                do {
                    let reponse = try await GitHubAPIClient.shared.searchUsers(keyword: viewState.keyword)
                    print("stop")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    SearchScreen()
}
