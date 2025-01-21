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

extension GitHubAPIClient {
            
    @MainActor
    func openLoginPage() throws {
        // ログインURLの作成
        guard var components = URLComponents(string: "https://github.com/login/oauth/authorize") else {
            throw GitHubAPIClientError.loginError
        }
        lastLoginStateID = UUID().uuidString // 多重ログイン防止のためログインセッションのIDを記録
        components.queryItems = [
            URLQueryItem(name: "client_id", value: PrivateConstants.clientID),
            URLQueryItem(name: "redirect_uri", value: "ikehgithubapi://callback"), // Callback URL
            URLQueryItem(name: "state", value: lastLoginStateID)
        ]
        guard let loginURL = components.url else {
            throw GitHubAPIClientError.loginError
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
            throw GitHubAPIClientError.loginError
        }
        
        if state != self.lastLoginStateID {
            // 最後に開いたログインページのコールバックではない場合
            throw GitHubAPIClientError.loginError
        }
        
        return sessionCode // 初回認証時にのみ利用する一時的なcode
    }
    
    func logout() async {
        // TODO: delete処理
        // https://docs.github.com/ja/apps/creating-github-apps/authenticating-with-a-github-app/refreshing-user-access-tokens
        await tokenManager.removeAll()
    }
    
   
    func updateAccessToken() async throws {
        
        guard let refreshToken = await tokenManager.refreshToken else {
            // TODO
            throw MessageError(description: "error")
        }
        
        let request = GitHubAPIRequest.UpdateAccessToken(clientID: GitHubAPIClient.PrivateConstants.clientID,
                                                         clientSecret: GitHubAPIClient.PrivateConstants.clientSecret,
                                                         refreshToken: refreshToken)
        
        let response = try await self.request(with: request)
        await tokenManager.set(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            accessTokenExpiredAt: calculateExpirationDate(expiresIn: response.accessTokenExpiresIn),
            refreshTokenExpiredAt: calculateExpirationDate(expiresIn: response.refreshTokenExpiresIn)
        )
    }
    
    func fetchFirstToken(sessionCode: String) async throws {
        let request = GitHubAPIRequest.FetchFirstToken(clientID: GitHubAPIClient.PrivateConstants.clientID,
                                                       clientSecret: GitHubAPIClient.PrivateConstants.clientSecret,
                                                       sessionCode: sessionCode)
                                       
                                               
        let response = try await self.request(with: request)

        await tokenManager.set(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            accessTokenExpiredAt: calculateExpirationDate(expiresIn: response.accessTokenExpiresIn),
            refreshTokenExpiredAt: calculateExpirationDate(expiresIn: response.refreshTokenExpiresIn)
        )
    }
}

// リフレッシュトークンの発行日時と有効期限（秒）を元に期限切れの時刻を計算
func calculateExpirationDate(startedAt: Date = .now, expiresIn: Int) -> Date {
    return startedAt.addingTimeInterval(TimeInterval(expiresIn))
}

struct FetchTokenResponse: Codable, Sendable {
    let accessToken: String
    let accessTokenExpiresIn: Int
    let refreshToken: String
    let refreshTokenExpiresIn: Int
    let tokenType: String
    let scope: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case accessTokenExpiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case refreshTokenExpiresIn = "refresh_token_expires_in"
        case tokenType = "token_type"
        case scope
    }
}
