import SwiftUI
import IKEHGitHubAPIClient

@MainActor
@Observable
final class LoginUserReposListViewState {
    
    // MARK: - Public Property
    
    var asyncRepoIDs: AsyncValues<Repo.ID, Error>
    var sortedBy: FetchLoginUserReposSortedBy
    var nextLink: RelationLink.Link?
    var error: Error?
    
    // MARK: - Private Property
    
    // MARK: Store
    
    private let tokenStore: TokenStoreProtocol
    private let repoStore: RepoStoreProtocol
        
    // MARK: - Computed Property
    
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
    
    var nextLinkPage: Int? {
        guard let pageString = nextLink?.queryItems["page"],
              let page = Int(pageString) else {
            return nil
        }
        return page
    }
    
    var repoCellStatusType: RepoCell.StatusType {
        switch sortedBy {
        case .fullNameAsc, .fullNameDesc, .recentlyPushed, .leastRecentlyPushed:
            return .pushedAt
        case .recentlyUpdated, .leastRecentlyUpdated:
            return .updatedAt
        }
    }
            
    // MARK: - LifeCycle
    
    init(
        tokenStore: TokenStoreProtocol = TokenStore.shared,
        repoStore: RepoStoreProtocol = RepoStore.shared,
        asyncRepoIDs: AsyncValues<Repo.ID, Error> = .initial,
        sortedBy: FetchLoginUserReposSortedBy = .recentlyUpdated,
        nextLink: RelationLink.Link? = nil,
        error: Error? = nil
    ) {
        self.tokenStore = tokenStore
        self.repoStore = repoStore
        self.asyncRepoIDs = asyncRepoIDs
        self.sortedBy = sortedBy
        self.nextLink = nextLink
        self.error = error
    }
}

// MARK: - Fetch User Repos
 
extension LoginUserReposListViewState {
        
    /// ユーザのリポジトリの取得
    /// - Parameters:
    ///   - page: ページ番号
    ///   - isLoadingMore: 続きを読み込むんでいるかどうか
    private func performFetchUserRepos(page: Int? = nil, isLoadingMore: Bool = false) async {
                
        switch asyncRepoIDs {
        case .initial, .loaded, .error:
            break
        case .loading, .loadingMore:
            return
        }
                
        guard let accessToken = await tokenStore.accessToken else {
            return
        }
        
        updateStatusBefore(isLoadingMore: isLoadingMore)
        do {
            let response = try await repoStore.fetchAuthenticatedUserRepos(
                accessToken: accessToken,
                sort: sortedBy.sort,
                direction: sortedBy.direction,
                perPage: 10,
                page: page
            )
            try await updateStatusAfter(with: response, isLoadingMore: isLoadingMore)
        } catch {
            // リポジトリの取得に失敗
            asyncRepoIDs = .error(error, asyncRepoIDs.values)
            self.error = error
        }
    }
    
    // MARK: - Helpers
    
    /// 通信前の状態の更新
    private func updateStatusBefore(isLoadingMore: Bool) {
        // 状態の更新
        asyncRepoIDs = isLoadingMore ?
            .loadingMore(asyncRepoIDs.values) :
            .loading(asyncRepoIDs.values)
        nextLink = nil
    }
              
    // 通信後の状態の更新
    private func updateStatusAfter(with response: ListResponse<Repo>, isLoadingMore: Bool) async throws {
        // ViewのユーザのリポジトリのID一覧を更新
        let newIDs = response.items.map { $0.id }
        let combinedIDs = isLoadingMore ? (asyncRepoIDs.values + newIDs) : newIDs
        withAnimation {
            asyncRepoIDs = .loaded(combinedIDs)
        }
        nextLink = response.relationLink?.next
    }
}

// MARK: - Actions

extension LoginUserReposListViewState {
    
    /// ユーザのリポジトリの取得
    func handleFetchUserRepos() async {
        await performFetchUserRepos()
    }
    
    /// ユーザのリポジトリの取得(追加読み込み)
    func handleFetchUserReposMore() async {
        guard let nextLinkPage else {
            return
        }
        await performFetchUserRepos(page: nextLinkPage, isLoadingMore: true)
    }
    
    /// ソート順が変更された
    func handleSortedChanged() async {
        await performFetchUserRepos()
    }
        
    func onAppear() async {
        // 初回読み込み時のみ検索を実行
        if asyncRepoIDs != .initial {
            return
        }
        await performFetchUserRepos()
    }
}
