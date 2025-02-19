//
//  StarredReposView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/25.
//

import SwiftUI

struct StarredReposView: View {
    
    // MARK: - Property

    @State private var state: StarredReposViewState = .init()
        
    // MARK: - View
    
    var body: some View {
        Content(loginUser: state.loginUser, handleLogInButtonTapped: {
            state.handleLogInButtonTapped()
        })
        .errorAlert(error: $state.error)
    }
}

// MARK: - StarredReposView+Content

extension StarredReposView {
    
    struct Content: View {
        
        // MARK: - Property
        
        @Namespace var namespace
        let loginUser: LoginUser?
        var handleLogInButtonTapped: () -> Void = {}
        
        // MARK: - View
        
        var body: some View {
            Group {
                if loginUser == nil {
                    NewLoginView(namespace: namespace) {
                        handleLogInButtonTapped()
                    }
                } else {
                    StarredReposResultView()
                }
            }
        }
    }
}

// MARK: - Preview

private extension StarredReposView {
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
                
                StarredReposView.Content(loginUser: loginUser)
                    .zIndex(-1)
            }
        }
    }
}

#Preview {
    StarredReposView.PreviewView()
}
