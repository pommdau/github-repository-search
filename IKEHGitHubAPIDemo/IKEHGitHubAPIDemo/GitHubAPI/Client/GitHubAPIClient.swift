//
//  GitHubAPIClient.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/07.
//

import Foundation

final actor GitHubAPIClient {

    static let shared: GitHubAPIClient = .init()
    private(set) var urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func searchRepos(keyword: String, page: Int? = nil) async throws -> SearchResponse<Repo> {
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        let response = try await search(with: GitHubAPIRequest.SearchRepos(keyword: keyword, page: page))
        return response
    }
    
    func searchUsers(keyword: String, page: Int? = nil) async throws -> SearchResponse<User> {
        let response = try await search(with: GitHubAPIRequest.SearchUsers(keyword: keyword, page: page))
        return response
    }
}
