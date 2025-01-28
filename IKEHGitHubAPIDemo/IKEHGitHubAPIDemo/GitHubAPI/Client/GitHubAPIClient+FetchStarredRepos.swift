//
//  GitHubAPIClient+FetchStarredRepos.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/27.
//

import Foundation

extension GitHubAPIClient {
    
    func fetchStarredRepos(page: Int? = nil, sortedBy: GitHubAPIRequest.StarredReposRequest.SortBy = .recentryStarred) async throws -> ListResponse<Repo> {
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
        return response
    }
}
