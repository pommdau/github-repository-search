//
//  StarredReposViewState.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/02.
//

import SwiftUI

@MainActor
@Observable
final class StarredReposViewState {
    
    // MARK: - Property
    
    private let loginUserStore: LoginUserStore
    private let githubAPIClient: GitHubAPIClient
    var error: Error?

    var loginUser: LoginUser? {
        loginUserStore.loginUser
    }

    // MARK: - LifeCycle
    
    init(
        loginUserStore: LoginUserStore = .shared,
        githubAPIClient: GitHubAPIClient = .shared
    ) {
        self.loginUserStore = loginUserStore
        self.githubAPIClient = githubAPIClient
    }
}

// MARK: - Login

extension StarredReposViewState {
    func handleLogInButtonTapped() {
        Task {
            do {
                try await githubAPIClient.openLoginPageInBrowser()
            } catch {
                self.error = error
            }
        }
    }
}
