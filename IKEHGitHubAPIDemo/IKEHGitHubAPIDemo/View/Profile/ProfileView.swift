//
//  AccountView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

struct ProfileView: View {
            
    // MARK: - Property
    
    @State private var state: ProfileViewState = .init()
        
    // MARK: - View
    
    var body: some View {
        Content(loginUser: state.loginUser) {
            state.handleLogInButtonTapped()
        }
    }
}

extension ProfileView {
    
    fileprivate struct Content: View {
        
        @Namespace var namespace
        let loginUser: LoginUser?
        var handleLogInButtonTapped: () -> Void = {}
        
        var body: some View {
            if let loginUser {
                LoginUserView(loginUser: loginUser, namespace: namespace)
            } else {
                NewLoginView(namespace: namespace) {
                    handleLogInButtonTapped()
                }
            }
        }
    }
}

// MARK: - Preview

private struct PreviewView: View {
    
    @State private var loginUser: LoginUser?

    private var loggedIn: Bool {
        loginUser != nil
    }
    
    var body: some View {
        ZStack {
            Toggle("Login: ", isOn: .bind(loggedIn, with: { loggedIn in
                withAnimation {
                    loginUser = loggedIn ? LoginUser.Mock.ikeh : nil
                }
            }))
            .frame(width: 120)
            .offset(y: -300)
            ProfileView.Content(loginUser: loginUser)
        }
    }
}

#Preview {
    PreviewView()
}
