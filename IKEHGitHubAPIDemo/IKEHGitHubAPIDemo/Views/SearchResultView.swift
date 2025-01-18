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
    var asyncRepos: AsyncValues<Repo, Error> = .initial
    var cancelSearching: () -> Void = {}
    var bottomCellOnAppear: (Int) -> Void = { _ in }
    
    var showNoResultLabel: Bool {
        // 検索結果が0であることが前提
        if !asyncRepos.values.isEmpty {
            return false
        }
        
        // 検索済み or エラーのとき
        switch asyncRepos {
        case .loaded, .error:
            return true
        default:
            return false
        }
    }
    
    var body: some View {
        List {
            switch asyncRepos {
            case .initial:
                Text("Search GitHub Repositories!")
                    .foregroundStyle(.secondary)
                    .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            case .loading:
                searchProgressView()
            case .loaded, .loadingMore, .error:
                if showNoResultLabel {
                    Text("No Result")
                        .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    reposList(asyncRepos: asyncRepos)
                }
            }
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
    private func reposList(asyncRepos: AsyncValues<Repo, Error>) -> some View {
        ForEach(asyncRepos.values) { repo in
            NavigationLink {
                // 遷移先のView
                Text(repo.fullName)
            } label: {
                RepoCell(repo: repo)
                    .padding(.vertical, 4)
                    .onAppear {
                        guard let lastRepo = asyncRepos.values.last else {
                            return
                        }
                        if lastRepo.id == repo.id {
                            bottomCellOnAppear(repo.id)
                        }
                    }
            }
        }
        if case .loadingMore = asyncRepos {
            searchProgressView()
        }
    }
    
    @ViewBuilder
    private func searchProgressView() -> some View {
        // https://zenn.dev/oka_yuuji/articles/807a9662f087f7
        ProgressView("searching...")
            .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
            .frame(maxWidth: .infinity, alignment: .center)
            .id(UUID())
    }
}

#Preview("SearchResultView_initial") {
    NavigationStack {
        SearchResultView(asyncRepos: .initial)
    }
}

#Preview("SearchResultView_loading") {
    NavigationStack {
        SearchResultView(asyncRepos:
                .loading([])
        )
    }
}

#Preview("SearchResultView_loaded") {
    NavigationStack {
        SearchResultView(asyncRepos:
                .loaded(Array(Repo.sampleData[0...6]))
        )
    }
}

#Preview("SearchResultView_loaded_norepos") {
    NavigationStack {
        SearchResultView(asyncRepos:
                .loaded([])
        )
    }
}

#Preview("SearchResultView_loadingmore") {
    NavigationStack {
        SearchResultView(asyncRepos:
                .loadingMore(Array(Repo.sampleData[0...2]))
        )
    }
}

#Preview("SearchResultView_error") {
    NavigationStack {
        SearchResultView(asyncRepos:
                .error(MessageError(description: "sample error"), [])
        )
    }
}
