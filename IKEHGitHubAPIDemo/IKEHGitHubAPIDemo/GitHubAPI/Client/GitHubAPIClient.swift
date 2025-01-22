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

    func searchRepos(searchText: String, page: Int? = nil) async throws -> SearchResponse<Repo> {
//        try? await Task.sleep(nanoseconds: 3_000_000_000)
        try await updateAccessTokenIfNeeded()
        let request = await GitHubAPIRequest.Search.Repos(accessToken: tokenStore.accessToken,
                                                          query: searchText,
                                                          page: page)
        let response: SearchResponse<Repo> = try await searchRequest(with: request)
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
