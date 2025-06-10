//
//  GitHubAPIClient+shared.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import Foundation
import IKEHGitHubAPIClient

extension GitHubAPIClient {
    
    /// GitHubAPIClientのシングルトン(Schemeで設定したEnvironment Variableで切り替える))
    static let shared: GitHubAPIClientProtocol = ProcessInfo.processInfo.environment["ENABLE_DUMMY_API"] == "true" ?
    gitHubAPIClientStubShared :
    gitHubAPIClientShared
            
    /// GitHubAPIClientStubのシングルトン
    private static let gitHubAPIClientStubShared: GitHubAPIClientStub = .init(
        // GitHubAPIClientAuthorizationProtocol
        openLoginPageInBrowserStubbedResponse: .success(()),
        recieveLoginCallBackURLAndFetchAccessTokenStubbedResponse: .success("stubbed_access_token"),
        logoutStubbedResponse: .success(()),
            
        // GitHubAPIClientFetchReposProtocol
        searchReposStubbedResponse: .success(.init(totalCount: 10, items: Repo.Mock.random(count: 10))),
        fetchAuthenticatedUserReposStubbedResponse: .success(.init(items: Repo.Mock.random(count: 10))),
        fetchUserReposStubbedResponse: .success(.init(items: Repo.Mock.random(count: 10))),
        fetchRepoStubbedResponse: .success(Repo.Mock.random()),
        
        // GitHubAPIClientFetchUserProtocol
        fetchLoginUserStubbedResponse: .success(LoginUser.Mock.ikeh),
        fetchUserStubbedResponse: .success(User.Mock.random()),
        
        // GitHubAPIClientStarredProtocol
        fetchStarredReposStubbedResponse: .success(.init(starredRepos: IKEHGitHubAPIClient.StarredRepo.Mock.randomWithRepos(Repo.Mock.random(count: 10)))),
        checkIsRepoStarredStubbedResponse: .success(false),
        starRepoStubbedResponse: .success(()),
        unstarRepoStubbedResponse: .success(())
    )
    /// GitHubAPIClientのシングルトン
    private static let gitHubAPIClientShared: GitHubAPIClient = .init(
        clientID: GitHubAPICredentials.clientID,
        clientSecret: GitHubAPICredentials.clientSecret,
        // swiftlint:disable:next force_unwrapping
        callbackURL: URL(string: "ikeh-github-repository-search://callback")!,
        // ログインユーザのリポジトリを取得するためにスコープの設定が必要
        scope: "repo",
        urlSession: URLSession.shared
    )
}
