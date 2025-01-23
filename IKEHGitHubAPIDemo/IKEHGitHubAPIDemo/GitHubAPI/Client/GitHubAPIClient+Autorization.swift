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
    /// アクセストークンの更新
    /// - Parameter forceUpdate: 更新を強制する
    func updateAccessTokenIfNeeded(forceUpdate: Bool = false) async throws {
        // 有効なアクセストークンがあれば何もしない
        if !forceUpdate, await tokenStore.isAccessTokenValid {
            return
        }

        // リフレッシュトークンが有効かどうか確認
        guard
            await tokenStore.isRefreshTokenValid,
            let refreshToken = await tokenStore.refreshToken
        else {
            throw GitHubAPIClientError.oauthError("有効な認証情報がありません。再度ログインを行ってください。")
        }
        
        // 更新処理
        let currentTime = Date()
        let request = GitHubAPIRequest.UpdateAccessToken(clientID: GitHubAPIClient.PrivateConstant.clientID,
                                                         clientSecret: GitHubAPIClient.PrivateConstant.clientSecret,
                                                         refreshToken: refreshToken)
        let response = try await self.oauthRequest(with: request)
        
        // プロパティに結果を保存
        await tokenStore.set(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            accessTokenExpiresAt: currentTime.addingExpirationInterval(response.accessTokenExpiresIn),
            refreshTokenExpiresAt: currentTime.addingExpirationInterval(response.refreshTokenExpiresIn)
        )
    }
}

// MARK: - Logout

extension GitHubAPIClient {
    
    /// ログアウト処理
    func logout() async throws  {
        // アクセストークンの更新
        try await updateAccessTokenIfNeeded()
        
        // ローカル上の認証情報の削除
        await tokenStore.removeAll()
        
        // サーバ上の認証情報の削除
        guard let accessToken = await tokenStore.accessToken else {
            return
        }
        let request = GitHubAPIRequest.DeleteAppAuthorization(
            clientID: GitHubAPIClient.PrivateConstant.clientID,
            clientSecret: GitHubAPIClient.PrivateConstant.clientSecret,
            accessToken: accessToken
        )
        try await self.noResponseRequest(with: request)
    }
}
