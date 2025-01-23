//
//  LoginUserViewState.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation

@MainActor @Observable
final class LoginUserViewState {

    let loginUser: LoginUser
    let gitHubAPIClient: GitHubAPIClient
    let loginUserStore: LoginUserStore
    
    // Error
    var showAlert = false
    var alertError: Error?
    
    init(
        loginUser: LoginUser,
        gitHubAPIClient: GitHubAPIClient = .shared,
        loginUserStore: LoginUserStore = .shared) {
            self.loginUser = loginUser
            self.gitHubAPIClient = gitHubAPIClient
            self.loginUserStore = loginUserStore
    }
    
    // MARK: - Actions
    
    func handleLogOutButtonTapped() {
        Task {
            do {
                try await gitHubAPIClient.logout()
            } catch {
                showAlert = true
                alertError = error
            }
            loginUserStore.delete()
        }
    }
}
