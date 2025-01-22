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
    private(set) var tokenStore: TokenStore

    // ログインのセッションID(最新のセッションのみ受け付ける)
    @MainActor
    var lastLoginStateID = ""
            
    init(urlSession: URLSession = URLSession.shared, tokenManager: TokenStore = TokenStore.shared) {
        self.urlSession = urlSession
        self.tokenStore = tokenManager
    }
}

extension GitHubAPIClient {
    func searchRepos(searchText: String, page: Int? = nil) async throws -> SearchResponse<Repo> {
//        try? await Task.sleep(nanoseconds: 3_000_000_000)
        try await updateAccessTokenIfNeeded()
        let request = await GitHubAPIRequest.Search.Repos(accessToken: tokenStore.accessToken,
                                                          query: searchText,
                                                          page: page)
        let response: SearchResponse<Repo> = try await searchRequest(with: request)
        return response
    }
    
    func fetchLoginUser() async throws -> LoginUser {
//        try? await Task.sleep(nanoseconds: 3_000_000_000)
        try await updateAccessTokenIfNeeded()
        guard let accessToken = await tokenStore.accessToken else {
            throw GitHubAPIClientError.oauthError("有効なトークンが見つかりませんでした")
        }
        let request = GitHubAPIRequest.FetchLoginUser(accessToken: accessToken)
        let response = try await defaultRequest(with: request)
        return response
    }
}
