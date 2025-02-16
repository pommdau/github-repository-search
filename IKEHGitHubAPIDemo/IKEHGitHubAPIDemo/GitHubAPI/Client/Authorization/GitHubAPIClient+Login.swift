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
    
    /// ブラウザ上でログインページを開く
    @MainActor
    func openLoginPageInBrowser() async throws {
        await tokenStore.addLastLoginStateID(UUID().uuidString) // 多重ログイン防止のためログインセッションのIDを記録
        let request = await GitHubAPIRequest.LoginPage(
            clientID: GitHubAPIClient.PrivateConstant.clientID,
            lastLoginStateID: tokenStore.lastLoginStateID
        )
        guard let loginURL = request.url else {
            throw GitHubAPIClientError.loginError("ログインURLの作成に失敗しました")
        }
        
        await UIApplication.shared.open(loginURL)
    }
    
    func handleLoginCallBackURL(_ url: URL) async throws -> LoginUser {
        let sessionCode = try await extactSessionCodeFromCallbackURL(url)
        try await fetchInitialToken(sessionCode: sessionCode)        
        return try await fetchLoginUser()
    }
            
    /// コールバックURLからログインセッションID(初回認証時にのみ利用する一時的なcode)を取得
    private func extactSessionCodeFromCallbackURL(_ url: URL) async throws -> String {
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
        
        return sessionCode
    }
}
