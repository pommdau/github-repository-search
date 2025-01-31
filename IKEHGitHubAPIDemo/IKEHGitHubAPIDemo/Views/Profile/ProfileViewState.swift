//
//  ProfileViewState.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

@MainActor @Observable
final class ProfileViewState {
    
    let loginUserStore: LoginUserStore
    let githubAPIClient: GitHubAPIClient
    
    var loginUser: LoginUser? {
        loginUserStore.value
    }
    
    var error: Error?
    
    init(loginUserStore: LoginUserStore = .shared,
         githubAPIClient: GitHubAPIClient = .shared) {
        self.loginUserStore = loginUserStore
        self.githubAPIClient = githubAPIClient
    }
    
    // MARK: - Actions
    
    func handleOnCallbackURL(_ url: URL) {
        Task {
            do {
                let loginUser = try await githubAPIClient.handleLoginCallBackURL(url)
                print("ログイン成功！")
                withAnimation {
                    loginUserStore.addValue(loginUser)
                }
            } catch {
                print(error.localizedDescription)
                self.error = error
            }
        }
    }
    
    func handleLogInButtonTapped() {
        Task {
            do {
                try await githubAPIClient.openLoginPageInBrowser()
            } catch {
                print(error.localizedDescription)
                self.error = error
            }
        }
    }
    
    func handleLogOutButtonTapped() {
        Task {
            do {
                try await githubAPIClient.logout()
            } catch {
                self.error = error
            }
            withAnimation {
                loginUserStore.deleteValue()
            }
        }
    }
}
