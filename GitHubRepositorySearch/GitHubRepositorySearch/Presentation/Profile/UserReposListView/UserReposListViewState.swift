////
////  UserReposListViewState.swift
////  GitHubRepositorySearch
////
////  Created by HIROKI IKEUCHI on 2025/05/10.
////
//
//import SwiftUI
//import IKEHGitHubAPIClient
//
//@MainActor
//@Observable
//final class UserReposListViewState {
//    
//    // MARK: Stores
//    let loginUserStore: LoginUserStore = .shared
//    let tokenStore: TokenStore = .shared
//    let repoStore: RepoStore = .shared
//    
//    let user: User = .Mock.random()
//    var asyncRepoIDs: AsyncValues<Repo.ID, Error> = .initial
//    var nextLinkForFetchingUserRepos: RelationLink.Link?
//    var sortedBy: FetchStarredReposSortedBy = .recentlyStarred
//    var error: Error?
//    
//    var loginUser: LoginUser? {
//        loginUserStore.loginUser
//    }
//    
//    var asyncRepos: AsyncValues<Repo, Error> {
//        let repos = asyncRepoIDs.values.compactMap { repoStore.valuesDic[$0] }
//        switch asyncRepoIDs {
//        case .initial:
//            return .initial
//        case .loading:
//            return .loading(repos)
//        case .loaded:
//            return .loaded(repos)
//        case .loadingMore:
//            return .loadingMore(repos)
//        case .error(let error, _):
//            return .error(error, repos)
//        }
//    }
//    
//    // MARK: - Actions
//    
//    /// スター済みリポジトリの取得
//    func fetchStarredRepos() {
//        // 「すでに検索中」の場合は何もしない
//        if case .loading = asyncRepoIDs {
//            return
//        }
//        Task {
//            // 必要な情報のチェック
//            guard let loginUser,
//                  let accessToken = await tokenStore.accessToken
//            else {
//    //            assertionFailure("通常通らない")
//                return
//            }
//            // 状態の更新
//            asyncRepoIDs = .loading(asyncRepoIDs.values)
//            nextLinkForFetchingUserRepos = nil
//                            
//            do {
//                let response = try await repoStore.fetchStarredRepos(
//                    userName: loginUser.login,
//                    accessToken: accessToken,
//                    sort: sortedBy.sort,
//                    direction: sortedBy.direction,
//                    perPage: 10,
//                    page: nil,
//                )
//                // スター済みリポジトリの取得に成功
//                try await starredRepoStore.addValues(response.starredRepos.map { StarredRepoTranslator.translate(from: $0) })
//                withAnimation {
//                    asyncRepoIDs = .loaded(response.starredRepos.map { $0.repo.id })
//                }
//                nextLinkForFetchingUserRepos = response.relationLink?.next
//            } catch {
//                // スター済みリポジトリの取得に失敗
//                asyncRepoIDs = .error(error, asyncRepoIDs.values)
//                self.error = error
//            }
//        }
//    }
//    
//    /// スター済みリポジトリの取得(追加読み込み)
//    func fetchStarredReposMore() {
//        // 他でダウンロード処理中であれば何もしない
//        switch asyncRepoIDs {
//        case .loading, .loadingMore:
//            return
//        default:
//            break
//        }
//        
//        Task {
//            // 必要な情報のチェック
//            guard let accessToken = await tokenStore.accessToken,
//                  let pageString = nextLinkForFetchingUserRepos?.queryItems["page"],
//                  let page = Int(pageString)
//            else {
//    //            assertionFailure("通常通らない")
//                return
//            }
//                        
//            // 状態の更新
//            asyncRepoIDs = .loadingMore(asyncRepoIDs.values)
//            nextLinkForFetchingUserRepos = nil
//                            
//            do {
//                let response = try await repoStore.fetchUserRepos(
//                    userName: user.login,
//                    accessToken: accessToken,
//                    sort: nil,
//                    direction: nil,
//                    perPage: 10,
//                    page: page
//                )
//                // スター済みリポジトリの取得に成功
//                withAnimation {
//                    asyncRepoIDs = .loaded(asyncRepoIDs.values + response.items.map { $0.id })
//                }
//                nextLinkForFetchingUserRepos = response.relationLink?.next
//            } catch {
//                // スター済みリポジトリの取得に失敗
//                asyncRepoIDs = .error(error, asyncRepoIDs.values)
//                self.error = error
//            }
//        }
//    }
//    
//    /// ソート順が変更された
//    func handleSortedChanged() {
//        fetchStarredRepos()
//    }
//        
//    func onAppear() {
//        // 初回読み込み時のみ検索を実行
//        if asyncRepoIDs != .initial {
//            return
//        }
//        fetchStarredRepos()
//    }
//}
