//
//  LoginViewState.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/03.
//

import SwiftUI
import class IKEHGitHubAPIClient.GitHubAPIClient

@MainActor
@Observable
final class LoginViewState {
    
    // MARK: - Property
    
    let tokenStore: TokenStoreProtocol
    let namespace: Namespace.ID?
    var error: Error?
    
    // MARK: - LifeCycle
    
    init(
        tokenStore: TokenStoreProtocol = TokenStore.shared,
        namespace: Namespace.ID? = nil
    ) {
        self.tokenStore = tokenStore
        self.namespace = namespace
    }
    
    // MARK: - Actions
    
    func handleLoginButtonTapped() {
        Task {
            do {
                try await tokenStore.openLoginPageInBrowser()
            } catch {
                self.error = error
            }
        }
    }
}
