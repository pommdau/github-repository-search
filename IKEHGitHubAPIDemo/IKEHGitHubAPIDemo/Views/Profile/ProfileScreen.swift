//
//  AccountView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

@MainActor @Observable
final class ProfileScreenViewState {

    let loginUserStore: LoginUserStore
    
    var loginUser: LoginUser? {
        loginUserStore.loginUser
    }
    
    init(loginUserStore: LoginUserStore = .shared) {
        self.loginUserStore = loginUserStore
    }
}

struct ProfileScreen: View {
    
    @State private var viewState: ProfileScreenViewState = .init()
    
    var body: some View {
        LoginView()
        if viewState.loginUser != nil {
            LoginUserView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ProfileScreen()
}
