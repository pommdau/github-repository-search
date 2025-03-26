//
//  GitHubAPIClient+Authorization.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/03/21.
//

import SwiftUI
import HTTPTypes
import HTTPTypesFoundation

// MARK: - ログイン

extension GitHubAPIClient {
    
    /// ブラウザ上でログインページを開く
    @MainActor
    func openLoginPageInBrowser() async throws {
        await tokenStore.updateLastLoginStateID(UUID().uuidString) // 多重ログイン防止のためログインセッションのIDを記録
        let request = await GitHubAPIRequest.LoginPage(
            clientID: clientID,
            lastLoginStateID: tokenStore.lastLoginStateID
        )
        guard let loginURL = request.url else {
            throw GitHubAPIClientError.loginError("ログインURLの作成に失敗しました")
        }
        
        await UIApplication.shared.open(loginURL)
    }
    
    /// コールバックURLの処理
    func handleLoginCallBackURL(_ url: URL) async throws {
        let sessionCode = try await extactSessionCodeFromCallbackURL(url)
        try await fetchInitialToken(sessionCode: sessionCode)
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

// MARK: - ログアウト

extension GitHubAPIClient {
    
    /// ログアウト処理
    func logout() async throws {
        do {
            // サーバ上の認証情報の削除
            guard let accessToken = await tokenStore.accessToken else {
                return
            }
            let request = GitHubAPIRequest.DeleteAppAuthorization(
                clientID: clientID,
                clientSecret: clientSecret,
                accessToken: accessToken
            )
            try await self.performRequestWithoutResponse(with: request)
        } catch {
            // ローカル上の認証情報の削除
            // サーバ上の認証情報の削除に失敗した場合もローカルのトークン情報を削除する
            await tokenStore.deleteAll()
            throw error
        }
        
        // ローカル上の認証情報の削除
        await tokenStore.deleteAll()
    }
}

// MARK: - トークン処理

extension GitHubAPIClient {
    
    /// 初回ログイン時のトークン取得
    func fetchInitialToken(sessionCode: String) async throws {
        let request = GitHubAPIRequest.FetchInitialToken(
            clientID: clientID,
            clientSecret: clientSecret,
            sessionCode: sessionCode
        )
        let response = try await self.performRequest(with: request)
        await tokenStore.updateTokens(
            accessToken: response.accessToken,
            accessTokenExpiresAt: Calendar.current.date(byAdding: .year, value: 1, to: .now) // 有効期限は一年
        )
    }
}
