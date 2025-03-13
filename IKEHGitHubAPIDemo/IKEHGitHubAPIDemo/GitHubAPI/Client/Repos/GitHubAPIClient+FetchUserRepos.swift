//
//  GitHubAPIClient+FetchUserRepos.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/03/08.
//

import Foundation

extension GitHubAPIClient {
    func fetchUserRepos(userName: String, page: Int? = nil) async throws -> ListResponse<Repo> {
        let request = await GitHubAPIRequest.FetchUserRepos(accessToken: tokenStore.accessToken, userName: userName, page: page)
        let response = try await sendRequest(with: request)
        return response
    }
}
