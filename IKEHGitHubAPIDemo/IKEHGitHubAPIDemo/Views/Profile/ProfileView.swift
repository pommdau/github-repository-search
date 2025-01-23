//
//  AccountView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var viewState: ProfileViewState = .init()
    
    var body: some View {
        if let loginUser = viewState.loginUser {
            LoginUserView(loginUser: loginUser)
        } else {
            LoginView()
        }
    }
}

#Preview {
    ProfileView()
}
