//
//  AccountView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: - Animated Transition
    
    @Namespace var namespace
    
    enum NamespaceID {
        case image1
        case button1
    }
    
    // MARK: - Property
    
    @State private var state: ProfileViewState = .init()
        
    // MARK: - View
    
    var body: some View {
        Group {
            if let loginUser = state.loginUser {
                LoginUserView(loginUser: loginUser, namespace: namespace) {
                    state.handleLogOutButtonTapped()
                }
            } else {
                LoginView(namespace: namespace)
            }
        }
        .onOpenURL { url in
            state.handleOnCallbackURL(url)
        }
        .errorAlert(error: $state.error)
    }
}

#Preview {
    ProfileView()
}
