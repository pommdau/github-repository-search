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
    
    func fetchAccessToken(sessionCode: String) async throws {
        let tokenURL = URL(string: "https://github.com/login/oauth/access_token")!
        
        // リクエストボディの作成
        let body: [String: String] = [
            "client_id": GitHubAPIClient.PrivateConstants.clientID,
            "client_secret": GitHubAPIClient.PrivateConstants.clientSecret,
            "code": sessionCode // コールバックで受け取った認証コード
        ]
        let bodyData = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let testBody = try JSONSerialization.jsonObject(with: bodyData, options: []) as! [String: String]
        
        // リクエスト設定
//        var request = URLRequest(url: tokenURL)
//        request.httpMethod = "POST"
//        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
//        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.contentType] = "application/json"
        headerFields[.accept] = "application/json"
        let request = HTTPRequest(method: .post,
                                  url: URL(string: "https://github.com/login/oauth/access_token")!,
                                  headerFields: headerFields)
        
        // URLSessionを使ってPOSTリクエストを送信
        let (data, response) = try await URLSession.shared.upload(for: request, from: bodyData)
        
        // レスポンスが失敗のとき
        if !(200..<300).contains(response.status.code) {
#if DEBUG
//            let errorString = String(data: data, encoding: .utf8) ?? ""
//            print(errorString)
#endif
            let gitHubAPIError: GitHubAPIError
            do {
                gitHubAPIError = try JSONDecoder().decode(GitHubAPIError.self, from: data)
            } catch {
                throw GitHubAPIClientError.responseParseError(error)
            }
            throw GitHubAPIClientError.apiError(gitHubAPIError)
        }
                
        // レスポンスが成功のとき
        #if DEBUG
//                let responseString = String(data: data, encoding: .utf8) ?? ""
//                print(responseString)
        #endif
        
        // レスポンスのデータをDTOへデコード
        var fetchInitialTokensResponse: FetchInitialTokensResponse
        do {
            fetchInitialTokensResponse = try JSONDecoder().decode(FetchInitialTokensResponse.self, from: data)
        } catch {
            throw GitHubAPIClientError.responseParseError(error)
        }

        await tokenManager.set(
            accessToken: fetchInitialTokensResponse.accessToken,
            refreshToken: fetchInitialTokensResponse.refreshToken,
            accessTokenExpiredAt: calculateExpirationDate(expiresIn: fetchInitialTokensResponse.accessTokenExpiresIn),
            refreshTokenExpiredAt: calculateExpirationDate(expiresIn: fetchInitialTokensResponse.refreshTokenExpiresIn)
        )
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
        
        let (data, response) = try await self.request(with: request)
        
        // レスポンスが失敗のとき
        if !(200..<300).contains(response.status.code) {
#if DEBUG
            let errorString = String(data: data, encoding: .utf8) ?? ""
            print(errorString)
#endif
            let gitHubAPIError: GitHubAPIError
            do {
                gitHubAPIError = try JSONDecoder().decode(GitHubAPIError.self, from: data)
            } catch {
                throw GitHubAPIClientError.responseParseError(error)
            }
            throw GitHubAPIClientError.apiError(gitHubAPIError)
        }
                
        // レスポンスが成功のとき
        #if DEBUG
                let responseString = String(data: data, encoding: .utf8) ?? ""
                print(responseString)
        #endif
        
        // レスポンスのデータをDTOへデコード
        var fetchInitialTokensResponse: FetchInitialTokensResponse
        do {
            fetchInitialTokensResponse = try JSONDecoder().decode(FetchInitialTokensResponse.self, from: data)
        } catch {
            throw GitHubAPIClientError.responseParseError(error)
        }

        await tokenManager.set(
            accessToken: fetchInitialTokensResponse.accessToken,
            refreshToken: fetchInitialTokensResponse.refreshToken,
            accessTokenExpiredAt: calculateExpirationDate(expiresIn: fetchInitialTokensResponse.accessTokenExpiresIn),
            refreshTokenExpiredAt: calculateExpirationDate(expiresIn: fetchInitialTokensResponse.refreshTokenExpiresIn)
        )
    }
    
    func fetchFirstToken(sessionCode: String) async throws {
        let request = GitHubAPIRequest.FetchFirstToken(clientID: GitHubAPIClient.PrivateConstants.clientID,
                                                       clientSecret: GitHubAPIClient.PrivateConstants.clientSecret,
                                                       sessionCode: sessionCode)
                                       
                                               
        let (data, response) = try await self.request(with: request)
        
        // レスポンスが失敗のとき
        if !(200..<300).contains(response.status.code) {
#if DEBUG
            let errorString = String(data: data, encoding: .utf8) ?? ""
            print(errorString)
#endif
            let gitHubAPIError: GitHubAPIError
            do {
                gitHubAPIError = try JSONDecoder().decode(GitHubAPIError.self, from: data)
            } catch {
                throw GitHubAPIClientError.responseParseError(error)
            }
            throw GitHubAPIClientError.apiError(gitHubAPIError)
        }
                
        // レスポンスが成功のとき
        #if DEBUG
                let responseString = String(data: data, encoding: .utf8) ?? ""
                print(responseString)
        #endif
        
        // レスポンスのデータをDTOへデコード
        var fetchInitialTokensResponse: FetchInitialTokensResponse
        do {
            fetchInitialTokensResponse = try JSONDecoder().decode(FetchInitialTokensResponse.self, from: data)
        } catch {
            throw GitHubAPIClientError.responseParseError(error)
        }

        await tokenManager.set(
            accessToken: fetchInitialTokensResponse.accessToken,
            refreshToken: fetchInitialTokensResponse.refreshToken,
            accessTokenExpiredAt: calculateExpirationDate(expiresIn: fetchInitialTokensResponse.accessTokenExpiresIn),
            refreshTokenExpiredAt: calculateExpirationDate(expiresIn: fetchInitialTokensResponse.refreshTokenExpiresIn)
        )
    }
}

// リフレッシュトークンの発行日時と有効期限（秒）を元に期限切れの時刻を計算
func calculateExpirationDate(startedAt: Date = .now, expiresIn: Int) -> Date {
    return startedAt.addingTimeInterval(TimeInterval(expiresIn))
}

struct FetchInitialTokensResponse: Codable, Sendable {
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
