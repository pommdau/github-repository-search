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
            SearchResultView(repos: viewState.repos, status: viewState.searchStatus) { _ in
                // 一番下のセルが表示された場合
                viewState.handleSearchMore()
            }
        }
        .searchable(text: $viewState.keyword, prompt: "Enter Keyword")
        .onSubmit(of: .search) {
            viewState.handleSearchKeyword()
        }
    }
}



#Preview {
//    SearchResultView2(asyncRepos: .loading(Array(Repo.sampleData[0...2])))
}

#Preview {
    SearchScreen()
}
