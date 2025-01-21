//
//  GitHubAPIClient.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/07.
//

import Foundation
import SwiftUI

final actor GitHubAPIClient {

    static let shared: GitHubAPIClient = .init()
    private(set) var urlSession: URLSession
    private(set) var tokenManager: TokenStore

    // ログイン処理の管理ID
    @MainActor
    @AppStorage("login-state-id")
    var lastLoginStateID = ""
    
//    // TODO: keychainへの登録
//    
//    @AppStorage("githubapi-access-token")
//    var accessToken: String?
//    
//    @AppStorage("githubapi-access-token-expired-at")
//    var accessTokenExpiredAt: Date?
//    
//    @AppStorage("githubapi-refresh-token")
//    var refreshToken: String?
//    
//    @AppStorage("githubapi-refresh-token-expired-at")
//    var refreshTokenExpiredAt: Date?
//    
//    var isAccessTokenValid: Bool {
//        guard let _ = accessToken,
//              let accessTokenExpiredAt else {
//            return false
//        }
//        // アクセストークンが有効期限内か
//        return accessTokenExpiredAt.compare(.now) == .orderedDescending
//    }
            
    init(urlSession: URLSession = URLSession.shared, tokenManager: TokenStore = TokenStore.shared) {
        self.urlSession = urlSession
        self.tokenManager = tokenManager
    }

    func searchRepos(searchText: String, page: Int? = nil) async throws -> SearchResponse<Repo> {
//        try? await Task.sleep(nanoseconds: 3_000_000_000)
//        let response = try await search(with: GitHubAPIRequest.SearchRepos(searchText: searchText, page: page))
        var response: SearchResponse<Repo>
        let relationLink: RelationLink?
        (response, relationLink) = try await search(with: GitHubAPIRequest.Search.Repos(query: searchText, page: page))
        response.relationLink = relationLink
        return response
    }
    
//    func searchRepos(query: String, page: Int? = nil) async throws -> SearchResponse<Repo> {
//        let response = try await search(with: GitHubAPIRequest.Search.Repos(query: query, page: page))
//        return response
//    }
//    
//    func searchUsers(searchText: String, page: Int? = nil) async throws -> SearchResponse<User> {
//        let response = try await search(with: GitHubAPIRequest.SearchUsers(searchText: searchText, page: page))
//        return response
//    }
}
