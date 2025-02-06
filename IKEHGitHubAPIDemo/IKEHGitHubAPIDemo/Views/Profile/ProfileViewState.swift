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
    
    var loginUser: LoginUser? {
        loginUserStore.value
    }
    
    // MARK: - LifeCycle
    
    init(loginUserStore: LoginUserStore = .shared) {
        self.loginUserStore = loginUserStore
    }
}
