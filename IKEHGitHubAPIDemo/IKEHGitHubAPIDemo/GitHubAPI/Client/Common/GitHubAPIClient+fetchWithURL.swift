//
//  GitHubAPIClient+fetchWithURL.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/26.
//

import Foundation

extension GitHubAPIClient {
    /// クエリを含む完全なURLが分かっている場合に利用できるGET用API通信
    func fetchWithURL<Response: Decodable>(url: URL) async throws -> Response {
        let request = await GitHubAPIRequest.RequestWithURL<Response>(accessToken: tokenStore.accessToken, rawURL: url)
        let response = try await sendRequest(with: request)
        return response
    }
}
