//
//  GitHubAPIClient+Login.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import UIKit
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
    func openLoginPageInBrowser() async throws {
        await tokenStore.setLastLoginStateID(UUID().uuidString) // 多重ログイン防止のためログインセッションのIDを記録
        guard let url = await Self.createLoginPageURL(clientID: GitHubAPIClient.PrivateConstant.clientID,
                                                      lastLoginStateID: tokenStore.lastLoginStateID) else {
            throw GitHubAPIClientError.loginError("ログインURLの作成に失敗しました")
        }
        await UIApplication.shared.open(url)
    }
    
    /// コールバックURLからログインセッションIDを取得
    @MainActor
    func extactSessionCodeFromCallbackURL(_ url: URL) async throws -> String {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems,
            let state = queryItems.first(where: { $0.name == "state" })?.value,
            let sessionCode = queryItems.first(where: { $0.name == "code" })?.value
        else {
            throw GitHubAPIClientError.loginError("コールバックURLの値が不正です")
        }
        
        let lastLoginStateID = await tokenStore.lastLoginStateID
        if  state != lastLoginStateID {
            // 最後に開いたログインページのコールバックではない場合
            throw GitHubAPIClientError.loginError("無効なログインセッションです")
        }
        
        return sessionCode // 初回認証時にのみ利用する一時的なcode
    }
    
    /// 初回ログイン時のトークン取得
    func fetchInitialToken(sessionCode: String) async throws {
        let request = GitHubAPIRequest.FetchInitialToken(clientID: GitHubAPIClient.PrivateConstant.clientID,
                                                         clientSecret: GitHubAPIClient.PrivateConstant.clientSecret,
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
}
