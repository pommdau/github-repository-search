//
//  LoginUserViewState.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/12.
//

import SwiftUI

@MainActor @Observable
final class LoginUserViewState {
    
    // MARK: - Property
        
    let loginUser: LoginUser
    let namespace: Namespace.ID?
    let loginUserStore: LoginUserStore
    let githubAPIClient: GitHubAPIClient
    var error: Error?

    // MARK: - LifeCycle
    
    init(
        loginUser: LoginUser,
        namespace: Namespace.ID?,
        loginUserStore: LoginUserStore = .shared,
        githubAPIClient: GitHubAPIClient = .shared
    ) {
        self.loginUser = loginUser
        self.namespace = namespace
        self.loginUserStore = loginUserStore
        self.githubAPIClient = githubAPIClient
    }
    
    // MARK: - Action
    
    /// ログアウトボタンが押された
    func handleLogOutButtonTapped() {
        Task {
            defer {
                withAnimation {
                    loginUserStore.deleteValue()
                }
            }
            do {
                try await githubAPIClient.logout()
            } catch {
                self.error = error // TODO: fix
            }
        }
    }
}
