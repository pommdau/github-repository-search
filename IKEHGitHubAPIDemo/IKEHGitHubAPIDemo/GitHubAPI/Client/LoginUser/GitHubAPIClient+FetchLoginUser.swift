//
//  GitHubAPIClient+FetchLoginUser.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/27.
//

import Foundation

extension GitHubAPIClient {
    
    func fetchLoginUser() async throws -> LoginUser {
//        try? await Task.sleep(nanoseconds: 3_000_000_000)
        guard let accessToken = await tokenStore.accessToken else {
            throw GitHubAPIClientError.oauthError("有効なトークンが見つかりませんでした")
        }
        let request = GitHubAPIRequest.FetchLoginUser(accessToken: accessToken)
        let response = try await sendRequest(with: request)
        return response
    }
    
    func fetchWithURL<Response: Decodable>(url: URL) async throws -> Response {
        let request = await GitHubAPIRequest.RequestWithURL<Response>(accessToken: tokenStore.accessToken, rawURL: url)
        let response = try await sendRequest(with: request)
        return response
    }
}
