//
//  GitHubAPIClient+Search.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/27.
//

import Foundation

extension GitHubAPIClient {
    func searchRepos(searchText: String, page: Int? = nil, sortedBy: GitHubAPIRequest.SearchReposRequest.SortBy = .bestMatch) async throws -> SearchResponse<Repo> {
//        try? await Task.sleep(nanoseconds: 3_000_000_000)
        // ログイン状態であればトークンの更新
        if await tokenStore.isLoggedIn {
            try await updateAccessTokenIfNeeded()
        }
        
        let request = await GitHubAPIRequest.SearchReposRequest(
            accessToken: tokenStore.accessToken,
            query: searchText,
            page: page,
            perPage: 10,
            sortedBy: sortedBy
        )
        let response = try await sendRequest(with: request)
        return response
    }
}
