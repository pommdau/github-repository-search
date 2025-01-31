//
//  AccountView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: - Animated Transition
    
    @Namespace var profileViewNamespace
    
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
                LoginUserView(loginUser: loginUser, namespace: profileViewNamespace) {
                    state.handleLogOutButtonTapped()
                }
            } else {
                LoginView(namespace: profileViewNamespace) {
                    state.handleLogInButtonTapped()
                }
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
