//
//  SearchResultView.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import SwiftUI
import IKEHGitHubAPIClient
import Shimmer

struct SearchResultView: View {
    
    // MARK: - Property
        
    // isSearchingは.searchableと同じViewで使用できないことに注意
    @Environment(\.isSearching)
    private var isSearching: Bool
    
    @Namespace var namespace
    
    let asyncRepos: AsyncValues<Repo, Error>
    let searchText: String
    var cancelSearching: () -> Void = {}
    var bottomCellOnAppear: (Repo.ID) -> Void = { _ in }
    
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
    
    // MARK: - LifeCycle
    
    // swiftlint:disable:next type_contents_order
    init(
        asyncRepos: AsyncValues<Repo, Error>,
        searchText: String = "",
        cancelSearching: @escaping () -> Void = {},
        bottomCellOnAppear: @escaping (Repo.ID) -> Void = { _ in },
    ) {
        self.asyncRepos = asyncRepos
        self.searchText = searchText
        self.cancelSearching = cancelSearching
        self.bottomCellOnAppear = bottomCellOnAppear
    }
    
    // MARK: - View
    
    var body: some View {
        List {
            switch asyncRepos {
            case .initial:
                initialLabel()
            case .loading:
                loadingView()
            case .loaded, .loadingMore, .error:
                if showNoResultLabel {
                    noResultView()
                } else {
                    reposList(asyncRepos: asyncRepos)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .onChange(of: isSearching) {
            if !isSearching {
                // 検索がキャンセルされた場合
                cancelSearching()
            }
        }
    }
    
    // MARK: - UI Parts
    
    @ViewBuilder
    private func initialLabel() -> some View {
        ContentUnavailableView("Search GitHub Repositories!", systemImage: "magnifyingglass")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    private func loadingView() -> some View {
        Group {
            ForEach(0..<5, id: \.self) { _ in
                RepoCell(repo: Repo.Mock.skeltonRepoCell)
                    .redacted(reason: .placeholder)
                    .shimmering()
            }
        }
        .id(UUID())
    }
    
    @ViewBuilder
    private func reposList(asyncRepos: AsyncValues<Repo, Error>) -> some View {
        ForEach(asyncRepos.values) { repo in
            NavigationLink {
                RepoDetailsView(repoID: repo.id)
                    .navigationTransition(.zoom(sourceID: "\(repo.id)", in: namespace))
            } label: {
                RepoCell(repo: repo)
                    .padding(.vertical, 4)
                    .matchedTransitionSource(id: "\(repo.id)", in: namespace)
                    .onAppear {
                        // 一番したのセルが表示されたことを検出する
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
        ProgressView()
            .frame(maxWidth: .infinity, alignment: .center)
            .id(UUID())
    }
    
    @ViewBuilder
    private func noResultView() -> some View {
        ContentUnavailableView.search(text: searchText)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

// MARK: - Preview

#Preview("初期状態") {
    NavigationStack {
        SearchResultView(asyncRepos: .initial)
    }
}

#Preview("読み込み中") {
    NavigationStack {
        SearchResultView(
            asyncRepos: .loading([])
        )
    }
}

#Preview("検索済み") {
    NavigationStack {
        SearchResultView(
            asyncRepos: .loaded(Repo.Mock.random(count: 10))
        )
    }
}

#Preview("検索済み(検索結果なし)") {
    NavigationStack {
        SearchResultView(asyncRepos: .loaded([]), searchText: "Swift")
    }
}

#Preview("追加の検索中") {
    NavigationStack {
        SearchResultView(
            asyncRepos: .loadingMore(Repo.Mock.random(count: 3))
        )
    }
}

#Preview("エラー(検索結果あり)") {
    NavigationStack {
        SearchResultView(
            asyncRepos: .error(
                MessageError(description: "sample error"),
                Repo.Mock.random(count: 3)
            )
        )
    }
}

#Preview("エラー(検索結果なし)") {
    NavigationStack {
        SearchResultView(
            asyncRepos: .error(MessageError(description: "sample error"), [])
        )
    }
}
