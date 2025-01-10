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

    func searchRepos(keyword: String) async throws -> SearchResponse<Repo> {
        let response = try await search(with: GitHubAPIRequest.SearchRepos(keyword: keyword))
        return response
    }
}
