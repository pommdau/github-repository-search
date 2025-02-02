//
//  StarredRepoListView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/02.
//

import SwiftUI

@MainActor @Observable
final class StarredRepoListViewState {
    let asyncRepos: AsyncValues<Repo, Error>
    
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
    
    init(asyncRepos: AsyncValues<Repo, Error>) {
        self.asyncRepos = asyncRepos
    }
}

struct StarredRepoListView: View {
    
    @Namespace private var namespace
    @State private var state: StarredRepoListViewState
    
    init(asyncRepos: AsyncValues<Repo, Error>) {
        _state = .init(initialValue: StarredRepoListViewState(asyncRepos: asyncRepos))
    }
    
    var body: some View {
        List {
            switch state.asyncRepos {
            case .initial, .loading:
                ForEach(0..<3, id: \.self) { _ in
                    RepoCell(repo: Repo.Mock.sampleDataForReposCellSkelton)
                        .redacted(reason: .placeholder)
                        .shimmering()
                }
            case .loaded, .loadingMore, .error:
                if state.showNoResultLabel {
                    VStack {
                        Image(systemName: "star.slash")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.secondary)
                            .frame(width: 36)
                        Text("There are no starred repositories")
                            .lineLimit(1)
                            .bold()
                    }
                    .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    ForEach(state.asyncRepos.values) { repo in
                        NavigationLink {
                            RepoDetailsView(repoID: repo.id)
                                .navigationBarBackButtonHidden()
                                .navigationTransition(.zoom(sourceID: "\(repo.id)", in: namespace))
                        } label: {
                            RepoCell(repo: repo)
                                .matchedTransitionSource(id:"\(repo.id)", in: namespace)
                        }
                    }
                    if case .loadingMore = state.asyncRepos {
                        // https://zenn.dev/oka_yuuji/articles/807a9662f087f7
                        ProgressView("Loading...")
                            .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .id(UUID())
                    }
                }
            }
        }
    }
    
}

// MARK: - Preview

#Preview("initial") {
    NavigationStack {
        StarredRepoListView(asyncRepos: .initial)
    }
}

#Preview("loading") {
    NavigationStack {
        StarredRepoListView(
            asyncRepos: .loading([])
        )
    }
}

#Preview("loaded") {
    NavigationStack {
        StarredRepoListView(
            asyncRepos: .loaded(Repo.Mock.createRandom(count: 10))
        )
    }
}

#Preview("loaded_no_result") {
    NavigationStack {
        StarredRepoListView(asyncRepos:.loaded([]))
    }
}

#Preview("loading_more") {
    NavigationStack {
        StarredRepoListView(
            asyncRepos: .loadingMore(Repo.Mock.createRandom(count: 3))
        )
    }
}

#Preview("error") {
    NavigationStack {
        StarredRepoListView(
            asyncRepos: .error(
                MessageError(description: "sample error"),
                Repo.Mock.createRandom(count: 3)
            )
        )
    }
}

#Preview("error_no_result") {
    NavigationStack {
        StarredRepoListView(
            asyncRepos: .error(MessageError(description: "sample error"), [])
        )
    }
}
