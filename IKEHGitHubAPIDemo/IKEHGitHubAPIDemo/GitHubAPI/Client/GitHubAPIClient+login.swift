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
    @MainActor
    func openLoginPage() throws {
        // ログインURLの作成
        guard var components = URLComponents(string: "https://github.com/login/oauth/authorize") else {
            throw GitHubAPIClientError.loginError("予期せぬエラーが発生しました")
        }
        lastLoginStateID = UUID().uuidString // 多重ログイン防止のためログインセッションのIDを記録
        components.queryItems = [
            URLQueryItem(name: "client_id", value: PrivateConstants.clientID),
            URLQueryItem(name: "redirect_uri", value: "ikehgithubapi://callback"), // Callback URL
            URLQueryItem(name: "state", value: lastLoginStateID)
        ]
        guard let loginURL = components.url else {
            throw GitHubAPIClientError.loginError("予期せぬエラーが発生しました")
        }

        UIApplication.shared.open(loginURL)
    }
    
    @MainActor
    func handleLoginCallbackURL(_ url: URL) throws -> String {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems,
            let sessionCode = queryItems.first(where: { $0.name == "code" })?.value,
            let state = queryItems.first(where: { $0.name == "state" })?.value
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
        let request = GitHubAPIRequest.OAuth.DeleteAppAuthorization(
            clientID: GitHubAPIClient.PrivateConstants.clientID,
            clientSecret: GitHubAPIClient.PrivateConstants.clientSecret,
            accessToken: accessToken
        )
        let response = try await self.request(with: request)
        print("stop")        
        await tokenStore.removeAll()
    }
}

// MARK: - Token

extension GitHubAPIClient {
    
    func fetchFirstToken(sessionCode: String) async throws {
        let request = GitHubAPIRequest.OAuth.FetchInitialToken(clientID: GitHubAPIClient.PrivateConstants.clientID,
                                                       clientSecret: GitHubAPIClient.PrivateConstants.clientSecret,
                                                       sessionCode: sessionCode)
                                       
                                               
        let response = try await self.request(with: request)

        await tokenStore.set(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            accessTokenExpiresAt: calculateExpirationDate(expiresIn: response.accessTokenExpiresIn),
            refreshTokenExpiresAt: calculateExpirationDate(expiresIn: response.refreshTokenExpiresIn)
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
        let request = GitHubAPIRequest.OAuth.UpdateAccessToken(clientID: GitHubAPIClient.PrivateConstants.clientID,
                                                               clientSecret: GitHubAPIClient.PrivateConstants.clientSecret,
                                                               refreshToken: refreshToken)
        let response = try await self.request(with: request)
        
        // プロパティに結果を保存
        await tokenStore.set(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            accessTokenExpiresAt: calculateExpirationDate(expiresIn: response.accessTokenExpiresIn),
            refreshTokenExpiresAt: calculateExpirationDate(expiresIn: response.refreshTokenExpiresIn)
        )
    }
}

// リフレッシュトークンの発行日時と有効期限（秒）を元に期限切れの時刻を計算
fileprivate func calculateExpirationDate(startedAt: Date = .now, expiresIn: Int) -> Date {
    return startedAt.addingTimeInterval(TimeInterval(expiresIn))
}
