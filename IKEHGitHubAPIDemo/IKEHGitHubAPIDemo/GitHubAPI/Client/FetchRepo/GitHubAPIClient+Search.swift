//
//  GitHubAPIClient+Search.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/27.
//

import Foundation

extension GitHubAPIClient {
    func searchRepos(searchText: String, page: Int? = nil, sort: String? = nil, order: String? = nil) async throws -> SearchResponse<Repo> {
//        try? await Task.sleep(nanoseconds: 3_000_000_000)
        let request = await GitHubAPIRequest.SearchReposRequest(
            accessToken: tokenStore.accessToken,
            query: searchText,
            sort: sort,
            order: order,
            page: page,
            perPage: 10
        )
        let response = try await sendRequest(with: request)
        return response
    }
}
