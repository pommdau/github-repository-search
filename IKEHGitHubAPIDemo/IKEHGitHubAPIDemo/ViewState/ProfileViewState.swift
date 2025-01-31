//
//  ProfileViewState.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation

@MainActor @Observable
final class ProfileViewState {

    let loginUserStore: LoginUserStore
    
    var loginUser: LoginUser? {
        loginUserStore.value
    }
    
    init(loginUserStore: LoginUserStore = .shared) {
        self.loginUserStore = loginUserStore
    }
}
