//
//  RootTabViewState.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/19.
//

import SwiftUI

@MainActor
@Observable
final class RootTabViewState {
    
    // MARK: - Property
        
    let loginUserStore: LoginUserStore
    let githubAPIClient: GitHubAPIClient
    var error: Error?

    // MARK: - LifeCycle
    
    init(
        loginUserStore: LoginUserStore = .shared,
        githubAPIClient: GitHubAPIClient = .shared
    ) {
        self.loginUserStore = loginUserStore
        self.githubAPIClient = githubAPIClient
    }
    
    // MARK: - Action
    
    func handleOnCallbackURL(_ url: URL) {
        Task {
            do {
                try await githubAPIClient.handleLoginCallBackURL(url)
                let loginUser = try await githubAPIClient.fetchLoginUser()                
                withAnimation {
                    loginUserStore.addValue(loginUser)
                }
            } catch {
                self.error = error
            }
        }
    }
}
