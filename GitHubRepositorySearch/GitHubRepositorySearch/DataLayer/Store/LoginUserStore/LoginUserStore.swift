//
//  LoginUserStore.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import SwiftUI
import IKEHGitHubAPIClient

@MainActor
@Observable
final class LoginUserStore: LoginUserStoreProtocol {
    
    // MARK: - Property
        
    static let shared: LoginUserStore = .init()
    
    private(set) var userDefaults: UserDefaults?
    private let tokenStore: TokenStoreProtocol
    private let gitHubAPIClient: GitHubAPIClient

    var loginUser: LoginUser?
        
    // MARK: - LifeCycle

    init(
        userDefaults: UserDefaults = .standard,
        tokenStore: TokenStoreProtocol = TokenStore.shared,
        gitHubAPIClient: GitHubAPIClient = GitHubAPIClient.shared,
    ) {
        self.userDefaults = userDefaults
        self.tokenStore = tokenStore
        self.gitHubAPIClient = gitHubAPIClient
        Task {
            fetchValue()
        }
    }
    
    // MARK: - GitHubAPI
    
    func fetchLoginUser() async throws {
        guard let accessToken = await tokenStore.accessToken else {
            return
        }        
        let loginUser = try await gitHubAPIClient.fetchLoginUser(accessToken: accessToken)
        withAnimation {
            // TODO: remove withAnimation
            addValue(loginUser)
        }
    }
}
