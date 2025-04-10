//
//  GitHubAPIClient+FetchRepos.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/03/21.
//

import Foundation

extension GitHubAPIClient {
    func searchRepos(searchText: String, page: Int? = nil, sort: String? = nil, order: String? = nil) async throws -> SearchResponse<Repo> {
        let request = await GitHubAPIRequest.SearchReposRequest(
            accessToken: tokenStore.accessToken,
            query: searchText,
            sort: sort,
            order: order,
            page: page,
            perPage: 10
        )
        let response = try await performRequest(with: request)
        return response
    }
    
    func fetchUserRepos(userName: String, page: Int? = nil) async throws -> ListResponse<Repo> {
        let request = await GitHubAPIRequest.FetchUserRepos(accessToken: tokenStore.accessToken, userName: userName, page: page)
        let response = try await performRequest(with: request)
        return response
    }
}
