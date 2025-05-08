//
//  ProfileViewState.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import Foundation

@MainActor
@Observable
final class ProfileViewState {
    
    // MARK: - Property
        
    let loginUserStore: LoginUserStore
    var error: Error?
    
    var isLoggedIn: Bool {
        loginUserStore.loginUser != nil
    }
    
    // MARK: - LifeCycle
    
    init(loginUserStore: LoginUserStore = .shared) {
        self.loginUserStore = loginUserStore
    }
}
