//
//  LoginUserReposView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/27.
//

import SwiftUI

@MainActor
@Observable
final class LoginUserReposViewState {
    
    // MARK: - Property
    
    // MARK: 検索条件
    
    let url: URL
                
    // MARK: 検索結果
    
    private var asyncRepoIDs: AsyncValues<Repo.ID, Error> = .initial
    
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
    
    private var relationLink: RelationLink?
    var error: Error?
    
    // MARK: その他
    
    private(set) var searchTask: Task<(), Never>?
        
    let gitHubAPIClient: GitHubAPIClient
    let repoStore: RepoStore
    let loginUserStore: LoginUserStore
    let searchSuggestionStore: SearchSuggestionStore
    
    // MARK: - LifeCycle
    
    init(
        url: URL,
        gitHubAPIClient: GitHubAPIClient = .shared,
        repoStore: RepoStore = .shared,
        loginUserStore: LoginUserStore = .shared,
        searchSuggestionStore: SearchSuggestionStore = .shared
    ) {
        self.url = url
        self.gitHubAPIClient = gitHubAPIClient
        self.repoStore = repoStore
        self.loginUserStore = loginUserStore
        self.searchSuggestionStore = searchSuggestionStore
    }
    
    func fetchStarredRepos(link: RelationLink.Link? = nil, isLoadingMore: Bool = false) {
        
        // 状態の変更
        if isLoadingMore {
            asyncRepoIDs = .loadingMore(asyncRepoIDs.values)
        } else {
            asyncRepoIDs = .loading(asyncRepoIDs.values)
        }
        
        relationLink = nil // TODO 見直し
                                        
        searchTask = Task {
            try? await Task.sleep(for: .seconds(1))
            do {
                // 検索の実行
                                        
                let response: ListResponse<Repo> = try await gitHubAPIClient.fetchWithURL(url: url)

                // 検索に成功
                try await repoStore.addValues(response.items, updateStarred: false) // Storeに検索結果を保存
//                // ViewStateに検索結果を保存
//                relationLink = response.relationLink
//                withAnimation {
//                    if isLoadingMore {
//                        asyncRepoIDs = .loaded(asyncRepoIDs.values + response.repos.map { $0.id })
//                    } else {
//                        asyncRepoIDs = .loaded(response.repos.map { $0.id })
//                    }
//                }
            } catch {
                // 検索に失敗
                if Task.isCancelled {
                    // 検索が明示的にキャンセルされた
                    if asyncRepos.values.isEmpty {
                        asyncRepoIDs = .initial
                    } else {
                        asyncRepoIDs = .loaded(asyncRepoIDs.values)
                    }
                } else {
                    // エラーが発生した
                    asyncRepoIDs = .error(error, asyncRepoIDs.values)
                    self.error = error
                }
            }
        }
    }
    
    func onAppear() {
        // 初回読み込み時のみ実行
        if asyncRepoIDs != .initial {
            return
        }
        fetchStarredRepos()
    }
}

struct LoginUserReposView: View {
            
    // MARK: - Property
    
    @State private var state: LoginUserReposViewState
    
    // swiftlint:disable:next type_contents_order
    init(url: URL) {
        _state = .init(wrappedValue: LoginUserReposViewState(url: url))
    }
        
    // MARK: - View
    
    var body: some View {
        NavigationStack {
            AsyncValuesView(asyncValuesa: state.asyncRepos) {
                skeltonView()
            } loadingView: {
                skeltonView()
            } dataView: { repos in
                ForEach(repos) { repo in
                    NavigationLink {
                        RepoDetailsView(repoID: repo.id)
                    } label: {
                        RepoCell(repo: repo, statusType: .updatedAt)
                    }

                }
            } noResultView: {
                ContentUnavailableView.search
            }
        }
        .onAppear {
            state.onAppear()
        }
    }
    
    @ViewBuilder
    private func skeltonView() -> some View {
        Group {
            ForEach(0..<3, id: \.self) { _ in
                RepoCell(repo: Repo.Mock.sampleDataForReposCellSkelton)
                    .redacted(reason: .placeholder)
                    .shimmering()
            }
        }
        .id(UUID())
    }
}

#Preview {
    // swiftlint:disable:next force_unwrapping
    LoginUserReposView(url: URL(string: "https://api.github.com/users/octocat/repo")!)
}
