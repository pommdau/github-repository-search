//
//  GitHubAPIClient+FetchUser.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/03/08.
//

import Foundation

extension GitHubAPIClient {
    func fetchUser(login: String) async throws -> User {
        let request = await GitHubAPIRequest.FetchUser(accessToken: tokenStore.accessToken, userName: login)
        let response = try await sendRequest(with: request)
        return response
    }
}
