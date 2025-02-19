//
//  GitHubAPIClient+login.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/20.
//

import Foundation
import SwiftUI
import HTTPTypes
import HTTPTypesFoundation

// MARK: - Token

extension GitHubAPIClient {
    
    /// 初回ログイン時のトークン取得
    func fetchInitialToken(sessionCode: String) async throws {
        let request = GitHubAPIRequest.FetchInitialToken(
            clientID: clientID,
            clientSecret: clientSecret,
            sessionCode: sessionCode
        )
        let response = try await self.sendRequest(with: request)
        await tokenStore.updateTokens(
            accessToken: response.accessToken,
            accessTokenExpiresAt: Calendar.current.date(byAdding: .year, value: 1, to: .now) // 有効期限は一年
        )
    }
}
