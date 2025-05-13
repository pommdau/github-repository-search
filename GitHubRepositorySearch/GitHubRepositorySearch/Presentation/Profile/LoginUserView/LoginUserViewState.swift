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
       
    let tokenStore: TokenStoreProtocol
    let loginUserStore: LoginUserStoreProtocol
    let namespace: Namespace.ID?
    var error: Error?
    
    // TODO: 再検討
    var loginUser: LoginUser {
        loginUserStore.loginUser ?? .Mock.ikeh
    }
        
    init(
        tokenStore: TokenStoreProtocol = TokenStore.shared,
        loginUserStore: LoginUserStoreProtocol = LoginUserStore.shared,
        namespace: Namespace.ID?,
        error: Error? = nil
    ) {
        self.tokenStore = tokenStore
        self.loginUserStore = loginUserStore
        self.namespace = namespace
        self.error = error
    }
    
    func handleLogoutButtonTapped() {
        Task {
            do {
                try await tokenStore.logout()
                withAnimation {
                    loginUserStore.deleteValue()
                }
            } catch {
                self.error = error
            }
        }
    }
}
