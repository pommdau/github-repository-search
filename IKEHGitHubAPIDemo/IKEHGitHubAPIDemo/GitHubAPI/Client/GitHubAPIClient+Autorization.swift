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

// MARK: - Login

extension GitHubAPIClient {
    
    private static func createLoginPageURL(clientID: String, lastLoginStateID: String) async -> URL? {
        // ログインURLの作成
        guard var components = URLComponents(string: "https://github.com/login/oauth/authorize") else {
            return nil
        }
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: "ikehgithubapi://callback"), // Callback URL
            URLQueryItem(name: "state", value: lastLoginStateID)
        ]
        guard let loginURL = components.url else {
            return nil
        }
        
        return loginURL
    }
    
    @MainActor
    func openLoginPage() async throws {
        lastLoginStateID = UUID().uuidString // 多重ログイン防止のためログインセッションのIDを記録
        guard let url = await Self.createLoginPageURL(clientID: GitHubAPIClient.PrivateConstants.clientID,
                                                      lastLoginStateID: lastLoginStateID) else {
            throw GitHubAPIClientError.loginError("予期せぬエラーが発生しました")
        }
        await UIApplication.shared.open(url)
    }
    
    @MainActor
    func handleLoginCallbackURL(_ url: URL) throws -> String {
        // コールバックURLから情報を取得
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems,
            let state = queryItems.first(where: { $0.name == "state" })?.value,
            let sessionCode = queryItems.first(where: { $0.name == "code" })?.value
        else {
            throw GitHubAPIClientError.loginError("予期せぬエラーが発生しました")
        }
        
        if state != self.lastLoginStateID {
            // 最後に開いたログインページのコールバックではない場合
            throw GitHubAPIClientError.loginError("無効なログインセッションです")
        }
        
        return sessionCode // 初回認証時にのみ利用する一時的なcode
    }
}

// MARK: - Logout

extension GitHubAPIClient {
    func logout() async throws  {
        // アクセストークンの更新
        try await updateAccessTokenIfNeeded()
        guard let accessToken = await tokenStore.accessToken else {
            return
        }
        let request = GitHubAPIRequest.DeleteAppAuthorization(
            clientID: GitHubAPIClient.PrivateConstants.clientID,
            clientSecret: GitHubAPIClient.PrivateConstants.clientSecret,
            accessToken: accessToken
        )
        
        await tokenStore.removeAll()
        try await self.noResponseRequest(with: request)
    }
}

// MARK: - Token

extension GitHubAPIClient {
    
    func fetchFirstToken(sessionCode: String) async throws {
        let request = GitHubAPIRequest.FetchInitialToken(clientID: GitHubAPIClient.PrivateConstants.clientID,
                                                         clientSecret: GitHubAPIClient.PrivateConstants.clientSecret,
                                                         sessionCode: sessionCode)
        
        let currentTime = Date()
        let response = try await self.oauthRequest(with: request)

        await tokenStore.set(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            accessTokenExpiresAt: currentTime.addingExpirationInterval(response.accessTokenExpiresIn),
            refreshTokenExpiresAt: currentTime.addingExpirationInterval(response.refreshTokenExpiresIn)
        )
    }
    
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
        let request = GitHubAPIRequest.UpdateAccessToken(clientID: GitHubAPIClient.PrivateConstants.clientID,
                                                         clientSecret: GitHubAPIClient.PrivateConstants.clientSecret,
                                                         refreshToken: refreshToken)
        
        let currentTime = Date()
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
