//
//  StarredReposList.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/08.
//

import SwiftUI
import IKEHGitHubAPIClient

struct StarredReposListView: View {
    
    @State private var state: StarredReposListViewState = .init()
    
    var body: some View {
        NavigationStack {
            Content(
                asyncRepos: state.asyncRepos,
                starredRepos: state.starredRepos,
                repoCellStatusType: state.repoCellStatusType,
                bottomCellOnAppear: { _ in
                    Task {
                        await state.handleFetchStarredReposMore()
                    }
                }
            )
            .errorAlert(error: $state.error)
            .navigationTitle("Starred Repositories")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    sortedByToolbarItemContent()
                }
            }
            .onAppear {
                Task {
                    await state.onAppear()
                }
            }
        }
    }
    
    @ViewBuilder
    private func sortedByToolbarItemContent() -> some View {
        Menu {
            Picker("Sorted By", selection: $state.sortedBy) {
                ForEach(FetchStarredReposSortedBy.allCases) { type in
                    /// 選択項目の一覧
                    Text(type.title).tag(type)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onChange(of: state.sortedBy) { _, _ in
                Task {
                    await state.handleSortedChanged()
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .accessibilityLabel(Text("SortedBy icon"))
        }
    }
}

// MARK: - Content

extension StarredReposListView {
           
    struct Content: View {
        
        // MARK: - Property
        
        @Namespace private var namespace
        
        let asyncRepos: AsyncValues<Repo, Error>
        let starredRepos: [StarredRepo]
        var repoCellStatusType: RepoCell.StatusType = .starredAt
        var bottomCellOnAppear: (Repo.ID) -> Void = { _ in }
        
        // MARK: - View
        
        var body: some View {
            AsyncValuesList(asyncValues: asyncRepos) {
                loadingView()
            } loadingView: {
                loadingView()
            } dataView: { repos in
                dataView(repos: repos)
            } noResultView: {
                ContentUnavailableView(
                    "No Results",
                    systemImage: "star",
                    description: Text("No starred repositories found.")
                )
            }
        }
        
        // MARK: - View Components
        
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
        private func dataView(repos: [Repo]) -> some View {
            ForEach(repos) { repo in
                NavigationLink {
                    RepoDetailsView(repoID: repo.id)
                        .navigationTransition(.zoom(sourceID: "\(repo.id)", in: namespace))
                } label: {
                    RepoCell(
                        repo: repo,
                        starredRepo: starredRepos.first(where: { $0.repoID == repo.id }),
                        statusType: repoCellStatusType
                    )
                    .padding(.vertical, 4)
                    .matchedTransitionSource(id: "\(repo.id)", in: namespace)
                    .onAppear {
                        // 一番したのセルが表示されたことを検出
                        guard let lastRepo = repos.last else {
                            return
                        }
                        if lastRepo.id == repo.id {
                            bottomCellOnAppear(repo.id)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("initial") {
    StarredReposListView.Content(asyncRepos: .initial, starredRepos: [])
}

#Preview("loading") {
    StarredReposListView.Content(asyncRepos: .loading([]), starredRepos: [])
}

#Preview("loaded") {
    let repos: [Repo] = Repo.Mock.random(count: 5)
    NavigationStack {
        StarredReposListView.Content(
            asyncRepos: .loaded(repos),
            starredRepos: StarredRepo.Mock.randomWithRepos(repos)
        )
    }
}

#Preview("loaded_no_result") {
    StarredReposListView.Content(
        asyncRepos: .loaded([]),
        starredRepos: []
    )
}

#Preview("loading_more") {
    let repos: [Repo] = Repo.Mock.random(count: 5)
    NavigationStack {
        StarredReposListView.Content(
            asyncRepos: .loadingMore(repos),
            starredRepos: StarredRepo.Mock.randomWithRepos(repos)
        )
    }
}

#Preview("error") {
    let repos: [Repo] = Repo.Mock.random(count: 5)
    StarredReposListView.Content(
        asyncRepos: .error(MessageError(description: "No Search Results Error"), repos),
        starredRepos: StarredRepo.Mock.randomWithRepos(repos)
    )
}

#Preview("error_no_result") {
    StarredReposListView.Content(
        asyncRepos: .error(MessageError(description: "No Search Results Error"), []),
        starredRepos: []
    )
}
