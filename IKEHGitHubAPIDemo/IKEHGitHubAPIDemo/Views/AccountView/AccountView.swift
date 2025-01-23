//
//  AccountView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

struct AccountView: View {
    
    let loginUserStore: LoginUserStore
    
    init(loginUserStore: LoginUserStore = .shared) {
        self.loginUserStore = loginUserStore
    }
    
    var body: some View {
        if let loginUser = loginUserStore.loginUser {
            LoginUserView(loginUser: loginUser)
        } else {
            LoginView()
        }
    }
}

#Preview {
    AccountView()
}
