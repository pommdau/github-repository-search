//
//  GitHubAPIClient+Starred.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/27.
//
//  refs: https://docs.github.com/ja/rest/activity/starring?apiVersion=2022-11-28

import Foundation

extension GitHubAPIClient {
    
    func fetchStarredRepos(page: Int? = nil, sortedBy: GitHubAPIRequest.StarredReposRequest.SortBy = .recentryStarred) async throws -> [Repo] {
        // ログイン状態であればトークンの更新
        if await tokenStore.isLoggedIn {
            try await updateAccessTokenIfNeeded()
        }
        
        // TODO: fix
        let request = await GitHubAPIRequest.StarredReposRequest(
            userName: "pommdau",
            accessToken: tokenStore.accessToken
        )
        
        let response = try await sendRequest(with: request)
        return response.repos
    }
    
    func checkIsRepoStarred(ownerName: String, repoName: String) async throws -> Bool {
        try await updateAccessTokenIfNeeded()
        let request = await GitHubAPIRequest.CheckIsRepoStarredRequest(
            accessToken: tokenStore.accessToken ?? "",
            ownerName: ownerName,
            repoName: repoName
        )
        
        do {
            try await sendRequestWithoutResponseData(with: request)
        } catch {
            switch error {
            case let GitHubAPIClientError.apiError(error):
                if error.statusCode == 404 {
                    return false // スターされていない
                }
                throw error
            default:
                throw error
            }
        }
        return true // スター済み
    }
}
