//
//  GitHubAPIClient+User.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/03/21.
//

import Foundation

// MARK: - ユーザ情報の取得

extension GitHubAPIClient {
    
    /// 認証中のユーザを取得
    func fetchLoginUser() async throws -> LoginUser {
        guard let accessToken = await tokenStore.accessToken else {
            throw GitHubAPIClientError.oauthError("有効なトークンが見つかりませんでした")
        }
        let request = GitHubAPIRequest.FetchLoginUser(accessToken: accessToken)
        let response = try await performRequest(with: request)
        return response
    }
    
    /// ログイン名からユーザを取得
    func fetchUser(login: String) async throws -> User {
        let request = await GitHubAPIRequest.FetchUser(accessToken: tokenStore.accessToken, userName: login)
        let response = try await performRequest(with: request)
        return response
    }
}
