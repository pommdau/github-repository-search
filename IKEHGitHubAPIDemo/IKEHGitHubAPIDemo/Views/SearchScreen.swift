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
            SearchResultView(keyword: viewState.keyword)
        }
        .searchable(text: $viewState.keyword, prompt: "Enter Keyword")
        .onSubmit(of: .search) {
            print(viewState.keyword)
        }
    }
}

@MainActor
@Observable
final class SearchScreenViewState {
    var keyword: String = "Swift"
}

#Preview {
    SearchScreen()
}
