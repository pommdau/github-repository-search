//
//  StarredReposList.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/08.
//

import SwiftUI
import struct IKEHGitHubAPIClient.Repo

struct StarredReposList: View {
    
    let loginUserStore: LoginUserStore = .shared
    let tokenStore: TokenStore = .shared
    let repoStore: RepoStore = .shared
    let starredRepoStore: StarredRepoStore = .shared

    @State var asyncRepoIDs: AsyncValues<Repo.ID, Error> = .initial
    var asyncRepos: AsyncValues<Repo, Error> {
        let repos = asyncRepoIDs.values.compactMap { repoStore.valuesDic[$0] }
        switch asyncRepoIDs {
        case .initial:
            return .initial
        case .loading:
            return .loading(repos)
        case .loaded:
            return .loaded(repos)
        case .loadingMore:
            return .loadingMore(repos)
        case .error(let error, _):
            return .error(error, repos)
        }
    }
    
    var body: some View {
        Content(asyncRepos: asyncRepos, starredRepos: [])
            .onAppear {
                Task {
                    guard let loginUser = loginUserStore.loginUser else {
                        return
                    }
                    let response = try await repoStore.fetchStarredRepos(
                        userName: loginUser.login,
                        accessToken: tokenStore.accessToken,
                        sort: nil,
                        direction: nil,
                        perPage: nil,
                        page: nil
                    )
                    try await starredRepoStore.addValues(response.starredRepos.map { StarredRepoTranslator.translate(from: $0) })
                    self.asyncRepoIDs = .loaded(response.starredRepos.map { $0.repo.id })
                }
            }
    }
}

// MARK: - Content

extension StarredReposList {
           
    struct Content: View {
        
        // MARK: - Property
        
        let asyncRepos: AsyncValues<Repo, Error>
        let starredRepos: [StarredRepo]
        var bottomCellOnAppear: (Repo.ID) -> Void = { _ in }
        
        // MARK: - View
        
        var body: some View {
            AsyncValuesView(asyncValuesa: asyncRepos) {
                loadingView()
            } loadingView: {
                loadingView()
            } dataView: { repos in
                ForEach(repos) { repo in
                    RepoCell(
                        repo: repo,
                        starredRepo: starredRepos.first(where: { $0.repoID == repo.id }),
                        statusType: .starredAt
                    )
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
            List {
                Group {
                    ForEach(0..<5, id: \.self) { _ in
                        RepoCell(repo: Repo.Mock.skeltonRepoCell)
                            .redacted(reason: .placeholder)
                            .shimmering()
                    }
                }
                .id(UUID())
            }
        }
    }
}

// MARK: - Preview

#Preview("initial") {
    StarredReposList.Content(asyncRepos: .initial, starredRepos: [])
}

#Preview("loading") {
    StarredReposList.Content(asyncRepos: .loading([]), starredRepos: [])
}

#Preview("loaded") {
    let repos: [Repo] = Repo.Mock.random(count: 5)
    StarredReposList.Content(
        asyncRepos: .loaded(repos),
        starredRepos: StarredRepo.Mock.randomWithRepos(repos)
    ) { id in
        print("bottom cell is onAppear: \(id)")
    }
}

#Preview("loaded_no_result") {
    StarredReposList.Content(
        asyncRepos: .loaded([]),
        starredRepos: []
    )
}

#Preview("loading_more") {
    let repos: [Repo] = Repo.Mock.random(count: 5)
    StarredReposList.Content(
        asyncRepos: .loadingMore(repos),
        starredRepos: StarredRepo.Mock.randomWithRepos(repos)
    )
}

#Preview("error") {
    let repos: [Repo] = Repo.Mock.random(count: 5)
    StarredReposList.Content(
        asyncRepos: .error(MessageError(description: "No Search Results Error"), repos),
        starredRepos: StarredRepo.Mock.randomWithRepos(repos)
    )
}

#Preview("error_no_result") {
    StarredReposList.Content(
        asyncRepos: .error(MessageError(description: "No Search Results Error"), []),
        starredRepos: []
    )
}
