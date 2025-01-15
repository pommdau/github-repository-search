//
//  SearchResultView2.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/15.
//

import SwiftUI

struct SearchResultView: View {
    
    // isSearchingは.searchableと同じViewで使用できないため、本Viewを切り出している
    @Environment(\.isSearching)
    private var isSearching: Bool
    
    let repos: [Repo]
    let status: SearchStatus
    var cancelSearching: () -> Void = {}
    var bottomCellOnAppear: (Int) -> Void = { _ in }
    
    var body: some View {
        VStack {
            switch status {
            case .initial:
                Text("Search GitHub Repositories!")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            case .loading, .loaded, .error:
                dataView(repos: repos, status: status)
            }
            Spacer()
        }
        .ignoresSafeArea(edges: .bottom)
        .onChange(of: isSearching) {
            if !isSearching {
                // 検索がキャンセルされた場合
                cancelSearching()
            }
        }
    }
    
    @ViewBuilder
    private func dataView(repos: [Repo], status: SearchStatus) -> some View {
        if status != .loading && repos.isEmpty {
            Text("No Result")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        } else {
            List {
                ForEach(repos) { repo in
                    RepoCell(repo: repo)
                        .padding(.vertical, 4)
                        .onAppear {
                            guard let lastRepo = repos.last else {
                                return
                            }
                            if lastRepo.id == repo.id {
                                bottomCellOnAppear(repo.id)
                            }
                        }
                }
                if status == .loading {
                    // https://zenn.dev/oka_yuuji/articles/807a9662f087f7
                    ProgressView("searching...")
                        .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .id(UUID())
                }
            }
        }
    }
}

#Preview("SearchResultView_loaded") {
    SearchResultView(repos: Array(Repo.sampleData[0...6]),
                      status: .loaded)
}

#Preview("SearchResultView_loading_initial") {
    NavigationStack {
        SearchResultView(repos: [],
                          status: .loading)
        
    }
}

#Preview("SearchResultView_loading") {
    NavigationStack {
        SearchResultView(repos: Array(Repo.sampleData[0...1]),
                          status: .loading)
        
    }
}
