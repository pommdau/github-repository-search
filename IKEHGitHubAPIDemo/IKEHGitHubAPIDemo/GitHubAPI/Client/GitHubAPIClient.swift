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
        let searchResponseDTO = try await request(with: GitHubAPIRequest.SearchRepos(keyword: keyword))
        let repos = searchResponseDTO.body.items.map { RepoTranslator.translate(from: $0) }
        return SearchResponse(headerFields: searchResponseDTO.httpFields, items: repos)
    }
}
