//
//  TokenStoreProtocol.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import Foundation

protocol TokenStoreProtocol: Actor {
    // MARK: - Property
    var accessToken: String? { get set }
    // MARK: - GitHub API
    func openLoginPageInBrowser() async throws
    func fetchAccessTokenWithCallbackURL(_ url: URL) async throws
    func logout() async throws
}
