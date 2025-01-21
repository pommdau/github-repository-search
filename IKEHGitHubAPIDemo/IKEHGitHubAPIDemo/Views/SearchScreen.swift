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
            Button("Debug") {
                Task {
                    try? GitHubAPIClient.shared.openLoginPage()
                }
            }
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
            LoginDebugView()
        }
        .searchable(text: $viewState.searchText, prompt: "Enter Keyword")
        .onSubmit(of: .search) {
            viewState.handleSearchText()
        }
        .onOpenURL { (url) in
            Task {
                let sessionCode = try await GitHubAPIClient.shared.handleLoginCallbackURL(url)
                print(sessionCode)
//                try? await GitHubAPIClient.shared.fetchAccessToken(sessionCode: sessionCode)
            }
        }
        .onAppear() {
//            try? GitHubAPIClient.shared.openLoginPage()
        }
    }
    
//    func openGitHubLogin() {
//        let clientId = "Iv23lisCHbtSIHnPe9qR" // GitHubで取得したClient ID
//        let redirectUri = "ikehgithubapi://callback" // コールバックURL
//        let scope = "repo user" // 必要なスコープ
//        let state = UUID().uuidString // CSRF対策用のランダム文字列
//
//        let authURL = """
//        https://github.com/login/oauth/authorize?client_id=\(clientId)&redirect_uri=\(redirectUri)&state=\(state)
//        """
//
//        if let url = URL(string: authURL) {
//            UIApplication.shared.open(url)
//        }
//    }
    
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
