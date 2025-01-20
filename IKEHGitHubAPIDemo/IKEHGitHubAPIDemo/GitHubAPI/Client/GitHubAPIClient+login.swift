//
//  GitHubAPIClient+login.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/20.
//

import Foundation
import HTTPTypes
import SwiftUI
import HTTPTypes
import HTTPTypesFoundation

extension GitHubAPIClient {
    
    @MainActor
    func openLoginPage() throws {
        // ログインURLの作成
        var components = URLComponents()
        components.scheme = "https"
        components.host = "github.com"
        components.path = "/login/oauth/authorize"
        lastLoginStateID = UUID().uuidString
        components.queryItems = [
            URLQueryItem(name: "client_id", value: PrivateConstants.clientID),
            URLQueryItem(name: "redirect_uri", value: "ikehgithubapi://callback"), // Callback URL
            URLQueryItem(name: "scope", value: "repo"), // Callback URL
            URLQueryItem(name: "state", value: lastLoginStateID)
        ]
        
        guard let loginURL = components.url else {
            throw GitHubAPIClientError.loginError
        }
        
        Task { @MainActor in
            UIApplication.shared.open(loginURL)
        }
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
    
    func fetchAccessToken(sessionCode: String) async throws -> String {
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
                

//        
//        // レスポンスを確認
//        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            
//            let errorString = String(data: data, encoding: .utf8) ?? ""
//            print(errorString)
//            
//            throw NSError(domain: "GitHubAPI", code: 0,
//                          userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])
//        }
//        
//        // レスポンスからアクセストークンを抽出
//        guard
//            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//            let accessToken = json["access_token"] as? String
//        else {
//            throw NSError(domain: "GitHubAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse access token"])
//        }
//        
//        return accessToken
        
        return ""
    }
    
}
