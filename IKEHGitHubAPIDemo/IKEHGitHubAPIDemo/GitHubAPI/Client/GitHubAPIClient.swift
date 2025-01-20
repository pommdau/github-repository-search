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

    // ログイン処理の管理ID
    @MainActor
    @AppStorage("login-state-id")
    var lastLoginStateID = ""
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func searchRepos(searchText: String, page: Int? = nil) async throws -> SearchResponse<Repo> {
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        let response = try await search(with: GitHubAPIRequest.SearchRepos(searchText: searchText, page: page))
        return response
    }
    
    func searchUsers(searchText: String, page: Int? = nil) async throws -> SearchResponse<User> {
        let response = try await search(with: GitHubAPIRequest.SearchUsers(searchText: searchText, page: page))
        return response
    }
}
