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

    func searchRepos(keyword: String) async throws -> [Repo] {
        let result = try await request(with: GitHubAPIRequest.SearchRepos(keyword: keyword))
        print(result.1)
        let response = result.0
        return response.items.map { RepoTranslator.translate(from: $0) }
    }
}
