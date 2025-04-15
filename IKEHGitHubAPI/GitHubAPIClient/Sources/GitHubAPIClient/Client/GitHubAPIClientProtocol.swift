//
//  File.swift
//  GitHubAPIClient
//
//  Created by HIROKI IKEUCHI on 2025/04/14.
//

import Foundation

public protocol GitHubAPIClientProtocol: Actor {
//    @Dependency(GitHubOAuthCredentials.self) private var credentials
    // MARK: Authorization
    @MainActor func openLoginPageInBrowser() async throws
    func handleLoginCallBackURLAndFetchAccessToken(_ url: URL) async throws -> String
    func logout(accessToken: String) async throws
//    public var handleLoginCallbackURLAndFetchAccessToken: @Sendable (_ callbackURL: URL) async throws -> String
}
