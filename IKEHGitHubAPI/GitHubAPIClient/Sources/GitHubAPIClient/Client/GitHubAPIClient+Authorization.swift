//
//  File.swift
//  GitHubAPIClient
//
//  Created by HIROKI IKEUCHI on 2025/04/13.
//

import UIKit
import GitHubRESTAPI
import Dependencies
import DependenciesMacros

// MARK: - ログイン

extension GitHubAPIClient {
    
    /// ブラウザでログインページを開く
    @MainActor
    public func openLoginPageInBrowser() async throws {
        // ログインセッションIDの作成
        let loginStateID = UUID().uuidString
        await setLastLoginStateID(loginStateID)
        
        let request = GitHubRESTAPIRequest.LoginPage(
            clientID: clientID,
            callbackURL: callbackURL,
            lastLoginStateID: loginStateID,
        )
        guard let url = request.url else {
            throw GitHubAPIClientError.loginError("Failed to create URL")
        }
        await UIApplication.shared.open(url)
    }
    
    /// コールバックURLの処理
    public func handleLoginCallBackURLAndFetchAccessToken(_ url: URL) async throws -> String {        
        let sessionCode = try await extractSessionCodeFromCallbackURL(url)
        return try await fetchInitialToken(sessionCode: sessionCode)
    }
    
    /// コールバックURLからログインセッションID(初回認証時にのみ利用する一時的なcode)を取得
    private func extractSessionCodeFromCallbackURL(_ url: URL) async throws -> String {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems,
            let state = queryItems.first(where: { $0.name == "state" })?.value,
            let sessionCode = queryItems.first(where: { $0.name == "code" })?.value
        else {
            throw GitHubAPIClientError.loginError("コールバックURLの値が不正です")
        }
        
        if  state != lastLoginStateID {
            // 最後に開いたログインページのコールバックではない場合
            throw GitHubAPIClientError.loginError("無効なログインセッションです")
        }
        
        return sessionCode
    }
        
    /// 初回ログイン時のトークン取得
    private func fetchInitialToken(sessionCode: String) async throws -> String {
        let request = GitHubRESTAPIRequest.FetchInitialToken(
            clientID: clientID,
            clientSecret: clientSecret,
            sessionCode: sessionCode
        )
        let response = try await self.performRequest(with: request)
        return response.accessToken
    }
}


// MARK: - ログアウト

extension GitHubAPIClient {
    
    /// ログアウト(サーバ上の認証情報の削除)
    public func logout(accessToken: String) async throws {
        let request = GitHubRESTAPIRequest.DeleteAppAuthorization(
            clientID: clientID,
            clientSecret: clientSecret,
            accessToken: accessToken
        )
        _ = try await self.performRequest(with: request)
    }
}
