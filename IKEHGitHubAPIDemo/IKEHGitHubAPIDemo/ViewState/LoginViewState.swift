//
//  LoginViewState.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation

@MainActor @Observable
final class LoginViewState {

    let gitHubAPIClient: GitHubAPIClient
    let loginUserStore: LoginUserStore
    
    // エラー表示
    var showAlert = false
    var alertError: Error?
    
    init(gitHubAPIClient: GitHubAPIClient = .shared,
         loginUserStore: LoginUserStore = .shared) {
        self.gitHubAPIClient = gitHubAPIClient
        self.loginUserStore = loginUserStore
    }

    // MARK: - Actions
    
    func handleLogInButtonTapped() {
        Task {
            do {
                try await gitHubAPIClient.openLoginPageInBrowser()
            } catch {
                print(error.localizedDescription)
                alertError = error
                showAlert = true
            }
        }
    }

    func handleOnCallbackURL(_ url: URL) {
        Task {
            let sessionCode = try await gitHubAPIClient.extactSessionCodeFromCallbackURL(url)
            do {
                try await gitHubAPIClient.fetchInitialToken(sessionCode: sessionCode)
                print("ログイン成功！")
                let loginUser = try await gitHubAPIClient.fetchLoginUser()
                loginUserStore.save(loginUser)
            } catch {
                print(error.localizedDescription)
                alertError = error
                showAlert = true                
            }
        }
    }
}
