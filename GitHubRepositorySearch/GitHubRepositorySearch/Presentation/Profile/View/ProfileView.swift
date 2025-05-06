//
//  ProfileView.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import SwiftUI
import IKEHGitHubAPIClient

// MARK: - ProfileView

@MainActor
@Observable
final class ProfileViewState {
    
    // MARK: - Property
        
    let loginUserStore: LoginUserStore
    var error: Error?
    
    var loginUser: LoginUser? {
        loginUserStore.loginUser
    }
    
    // MARK: - LifeCycle
    
    init(loginUserStore: LoginUserStore = .shared) {
        self.loginUserStore = loginUserStore
    }
}

struct ProfileView: View {
    
    @State private var state: ProfileViewState = .init()
    
    var body: some View {
        Content(loginUser: LoginUser.Mock.ikeh)
    }
}

// MARK: - Content

private extension ProfileView {
    
    struct Content: View {
        
        @Namespace var namespace
        let loginUser: LoginUser?
        
        var body: some View {
            if let loginUser {
                LoginUserView(loginUser: loginUser, namespace: namespace)
            } else {
                LoginView(namespace: namespace)
            }
        }
    }
}


// MARK: - Preview

private extension ProfileView {
    struct PreviewView: View {
        
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
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.blue.opacity(0.4))
                        .padding(-8)
                )
                .frame(width: 120)
                .offset(y: -300)
                .zIndex(1)

                ProfileView.Content(loginUser: loginUser)
            }
        }
    }
}

#Preview {
    ProfileView.PreviewView()
}
