//
//  StarredRepoView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/25.
//

import SwiftUI

@MainActor @Observable
final class StarredRepoViewState {
    
    let loginUserStore: LoginUserStore
    let githubAPIClient: GitHubAPIClient
    let repoStore: RepoStore
    var sortedBy: GitHubAPIRequest.StarredReposRequest.SortBy = .recentryStarred
    
    var loginUser: LoginUser? {
        loginUserStore.value
    }
    
    private(set) var asyncRepoIDs: AsyncValues<Repo.ID, Error> = .initial
    
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
    
    private var fetchStarredReposTask: Task<(), Never>?
    
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
    
    init(loginUserStore: LoginUserStore = .shared, githubAPIClient: GitHubAPIClient = .shared, repoStore: RepoStore = .shared) {
        self.loginUserStore = loginUserStore
        self.githubAPIClient = githubAPIClient
        self.repoStore = repoStore
    }
    
    //    convenience init() {
    //        self.init(starredRepoStore: StarredRepoStore.shared)
    //    }
    //
    
    func handleFetchingStarredRepos() {
        
        // すでに検索中であれば何もしない
        if case .loading = asyncRepoIDs {
            return
        }
        
        guard let userName = loginUser?.login else {
            return
        }
        
        asyncRepoIDs = .loading(asyncRepoIDs.values)
        relationLink = nil
        
        fetchStarredReposTask = Task {
            do {
                // 検索: 成功
                let response = try await githubAPIClient.fetchStarredRepos(userName: userName, sortedBy: sortedBy)
                try await repoStore.addValues(response.repos)
                withAnimation {
                    asyncRepoIDs = .loaded(response.repos.map { $0.id })
                }
                relationLink = response.relationLink
            } catch {
                // 検索: 失敗
                if Task.isCancelled {
                    if asyncRepos.values.isEmpty {
                        asyncRepoIDs = .initial
                    } else {
                        asyncRepoIDs = .loaded(asyncRepoIDs.values)
                    }
                } else {
                    asyncRepoIDs = .error(error, asyncRepoIDs.values)
                    self.error = error
                }
            }
        }
    }
    
    /// 検索結果の続きの読み込み
    func fetchStarredReposMore() {
        
        // 他でダウンロード処理中であればキャンセル
        switch asyncRepos {
        case .loading, .loadingMore:
            return
        default:
            break
        }
        
        guard
            let userName = loginUser?.login,
            let nextLink = relationLink?.next // リンク情報がなければ何もしない
        else {
            return
        }
        
        // 検索開始
        asyncRepoIDs = .loadingMore(asyncRepoIDs.values)
        fetchStarredReposTask = Task {
            do {
                // 検索に成功
                let response = try await githubAPIClient.fetchStarredRepos(userName: userName, page: nextLink.page, sortedBy: sortedBy)
                try await repoStore.addValues(response.repos)
                withAnimation {
                    asyncRepoIDs = .loaded(asyncRepoIDs.values + response.repos.map { $0.id })
                }
                relationLink = response.relationLink
            } catch {
                // 検索に失敗
                if Task.isCancelled {
                    asyncRepoIDs = .loaded(asyncRepoIDs.values)
                } else {
                    asyncRepoIDs = .error(error, asyncRepoIDs.values)
                    self.error = error
                }
            }
        }
    }
    
    /// ソート順が変更された際の再検索
    func handleSortedByChanged() {
        
        // 検索済み以外は何もしない
        // 有効な検索結果がなければ何もしない
        // リンク情報がなければ何もしない(=検索結果がこれ以上無いので並び替えだけでOK)(TODO: 見直せるかも)
        guard case .loaded = asyncRepos,
              !asyncRepoIDs.values.isEmpty,
              let _ = relationLink?.next,
              let userName = loginUser?.login
        else {
            return
        }
        
        asyncRepoIDs = .loading(asyncRepoIDs.values)
        fetchStarredReposTask = Task {
            do {
                let response = try await githubAPIClient.fetchStarredRepos(userName: userName, sortedBy: sortedBy)
                try await repoStore.addValues(response.repos)
                withAnimation {
                    asyncRepoIDs = .loaded(response.repos.map { $0.id })
                }
                relationLink = response.relationLink
            } catch {
                if Task.isCancelled {
                    if asyncRepos.values.isEmpty {
                        asyncRepoIDs = .initial
                    } else {
                        asyncRepoIDs = .loaded(asyncRepoIDs.values)
                    }
                } else {
                    asyncRepoIDs = .error(error, asyncRepoIDs.values)
                    self.error = error
                }
            }
        }
    }
    
    func onAppear() {
        Task {
            do {
                try await repoStore.fetchValues()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct StarredRepoView: View {
    
    @Namespace private var namespace
    @State private var state: StarredRepoViewState = .init()
    
    var handleLogInButtonTapped: () -> (Void) = {}
    
    var body: some View {
        
        if state.loginUser == nil {
            ZStack {
                List {
                    Button("Fetch") {
                        state.handleFetchingStarredRepos()
                    }
                    
                    Button("Fetch More") {
                        state.fetchStarredReposMore()
                    }
                }
                LoginView(namespace: namespace)
            }
        } else {
            NavigationStack {
                StarredRepoListView(asyncRepos: state.asyncRepos)
                    .errorAlert(error: $state.error)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Starred Repositories")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            toolbarItemContentSortedBy()
                        }
                    }
            }
            .onAppear {
                state.onAppear()
            }
        }
    }
    
    // MARK: - UI
    
    @ViewBuilder
    private func toolbarItemContentSortedBy() -> some View {
        Menu {
            Picker("Sorted By", selection: $state.sortedBy) {
                ForEach(GitHubAPIRequest.StarredReposRequest.SortBy.allCases) { type in
                    /// 選択項目の一覧
                    Text(type.title).tag(type)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onChange(of: state.sortedBy) { _, _ in
                state.handleSortedByChanged()
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
    }
}

// MARK: - Preview

#Preview("initial") {
    NavigationStack {
        StarredRepoView()
    }
}
