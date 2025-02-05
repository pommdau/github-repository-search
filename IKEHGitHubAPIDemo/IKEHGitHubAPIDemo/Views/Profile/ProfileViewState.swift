//
//  ProfileViewState.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

@MainActor @Observable
final class ProfileViewState {
    
    // MARK: - Property
        
    let loginUserStore: LoginUserStore
    let githubAPIClient: GitHubAPIClient
    var error: Error?
    
    var loginUser: LoginUser? {
        loginUserStore.value
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

// MARK: - Actions

extension ProfileViewState {
    
    // MARK: Log in
        
    /// ログインボタンが押された
    func handleLogInButtonTapped() {
        Task {
            do {
                try await githubAPIClient.openLoginPageInBrowser()
            } catch {
                self.error = error
            }
        }
    }
    
    /// ログインページからコールバックURLを受け取った際の処理
    func handleOnCallbackURL(_ url: URL) {
        Task {
            do {
                let loginUser = try await githubAPIClient.handleLoginCallBackURL(url)
                withAnimation {
                    loginUserStore.addValue(loginUser)
                }
            } catch {
                self.error = error
            }
        }
    }
    
    // MARK: Log out
    
    /// ログアウトボタンが押された
    func handleLogOutButtonTapped() {
        Task {
            do {
                try await githubAPIClient.logout()
                withAnimation {
                    loginUserStore.deleteValue()
                }
            } catch {
                self.error = error
            }
        }
    }
}
