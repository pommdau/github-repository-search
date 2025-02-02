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
    
    func handleOnCallbackURL(_ url: URL) {
        Task {
            do {
                let loginUser = try await githubAPIClient.handleLoginCallBackURL(url)
                print("ログイン成功！")
                withAnimation {
                    loginUserStore.addValue(loginUser)
                }
            } catch {
                self.error = error
            }
        }
    }
    
    func handleLogInButtonTapped() {
        Task {
            do {
                try await githubAPIClient.openLoginPageInBrowser()
            } catch {
                self.error = error
            }
        }
    }
    
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
