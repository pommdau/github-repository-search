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
    private let gitHubAPIClient: GitHubAPIClient

    var loginUser: LoginUser?
        
    // MARK: - LifeCycle

    init(
        userDefaults: UserDefaults = .standard,
        gitHubAPIClient: GitHubAPIClient = GitHubAPIClient.shared
    ) {
        self.userDefaults = userDefaults
        self.gitHubAPIClient = gitHubAPIClient
        Task {
            fetchValue()
        }
    }
    
    // MARK: - GitHubAPI
    
    func fetchLoginUser(accessToken: String) async throws {
        let loginUser = try await gitHubAPIClient.fetchLoginUser(accessToken: accessToken)
        addValue(loginUser)
    }
}
