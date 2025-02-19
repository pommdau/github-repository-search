//
//  SearchResultView2.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/15.
//

import SwiftUI
import Shimmer

struct SearchResultView: View {
    
    // isSearchingは.searchableと同じViewで使用できないため、本Viewを切り出している
    @Environment(\.isSearching)
    private var isSearching: Bool
    
    @Namespace var namespace
    
    let asyncRepos: AsyncValues<Repo, Error>
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
    
    let repoStore: RepoStore
    
    // swiftlint:disable:next type_contents_order
    init(
        asyncRepos: AsyncValues<Repo, Error>,
        cancelSearching: @escaping () -> Void = {},
        bottomCellOnAppear: @escaping (Repo.ID) -> Void = { _ in },
        repoStore: RepoStore = .shared
    ) {
        self.asyncRepos = asyncRepos
        self.cancelSearching = cancelSearching
        self.bottomCellOnAppear = bottomCellOnAppear
        self.repoStore = repoStore
    }
        
    var body: some View {
        List {
            switch asyncRepos {
            case .initial:
                initialLabel()
            case .loading:
                loadingView()
            case .loaded, .loadingMore, .error:
                if showNoResultLabel {
                    noResultLabel()
                } else {
                    reposList(asyncRepos: asyncRepos)
                }
            }
        }
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
        VStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.secondary)
                .frame(width: 36)
            Text("Search GitHub Repositories!")
                .foregroundStyle(.secondary)
                .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    private func loadingView() -> some View {
        Group {
            ForEach(0..<3, id: \.self) { _ in
                RepoCell(repo: Repo.Mock.sampleDataForReposCellSkelton)
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
        ProgressView("Searching...")
            .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
            .frame(maxWidth: .infinity, alignment: .center)
            .id(UUID())
    }
    
    @ViewBuilder
    private func noResultLabel() -> some View {
        VStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.secondary)
                .frame(width: 36)
            Text("No Results")
                .font(.title)
                .bold()
            Text("Check the spelling or try a new search")
                .foregroundStyle(.secondary)
        }
        .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

// MARK: - Preview

#Preview("initial") {
    NavigationStack {
        SearchResultView(asyncRepos: .initial)
    }
}

#Preview("loading") {
    NavigationStack {
        SearchResultView(
            asyncRepos: .loading([])
        )
    }
}

#Preview("loaded") {
    NavigationStack {
        SearchResultView(
            asyncRepos: .loaded(Repo.Mock.random(count: 10))
        )
    }
}

#Preview("loaded_no_result") {
    NavigationStack {
        SearchResultView(asyncRepos:.loaded([]))
    }
}

#Preview("loading_more") {
    NavigationStack {
        SearchResultView(
            asyncRepos: .loadingMore(Repo.Mock.random(count: 3))
        )
    }
}

#Preview("error") {
    NavigationStack {
        SearchResultView(
            asyncRepos: .error(
                MessageError(description: "sample error"),
                Repo.Mock.random(count: 3)
            )
        )
    }
}

#Preview("error_no_result") {
    NavigationStack {
        SearchResultView(
            asyncRepos: .error(MessageError(description: "sample error"), [])
        )
    }
}
