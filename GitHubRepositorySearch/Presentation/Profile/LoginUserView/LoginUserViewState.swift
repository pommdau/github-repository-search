//
//  LoginUserViewState.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import SwiftUI
import struct IKEHGitHubAPIClient.LoginUser

@MainActor
@Observable
final class LoginUserViewState {
    
    // MARK: - Property
           
    let tokenStore: TokenStoreProtocol
    let loginUserStore: LoginUserStoreProtocol
    let namespace: Namespace.ID?
    var error: Error?
    
    var loginUser: LoginUser {
        loginUserStore.loginUser ?? .Mock.ikeh
    }
        
    // MARK: - LifeCycle
    
    init(
        tokenStore: TokenStoreProtocol = TokenStore.shared,
        loginUserStore: LoginUserStoreProtocol = LoginUserStore.shared,
        namespace: Namespace.ID? = nil,
        error: Error? = nil
    ) {
        self.tokenStore = tokenStore
        self.loginUserStore = loginUserStore
        self.namespace = namespace
        self.error = error
    }
    
    // MARK: - Action
    
    /// ログアウトボタンがタップされた
    func handleLogoutButtonTapped() {
        Task {
            do {
                try await tokenStore.logout()
                loginUserStore.deleteValue()
            } catch {
                self.error = error
            }
        }
    }
}
