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
    
    // TODO 分離させてもいいかも
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
                LoginUserView(loginUser: loginUser, namespace: namespace)
            } else {
                NewLoginView(namespace: namespace)
            }
        }
        .errorAlert(error: $state.error)
    }
    
    @ViewBuilder
    fileprivate func content(loginUser: LoginUser?, state: ProfileViewState? = nil) -> some View {
        if let loginUser {
            LoginUserView(loginUser: loginUser, namespace: namespace)
        } else {
            LoginView(namespace: namespace) {
                state?.handleLogInButtonTapped()
            }
        }
    }
}

fileprivate struct MyContentView: View {
    
    @Namespace var namespace
    
    let loginUser: LoginUser?
    var state: ProfileViewState?
    
    var body: some View {
        if let loginUser {
            LoginUserView(loginUser: loginUser, namespace: namespace)
        } else {
            LoginView(namespace: namespace) {
                state?.handleLogInButtonTapped()
            }
        }
    }
}


struct PreviewView: View {
    
    private var profileView = ProfileView()
    @State var loginUser: LoginUser?
    
    var body: some View {
        Button("Toggle") {
            withAnimation {
                loginUser = (loginUser == nil) ? LoginUser.Mock.ikeh : nil
            }
        }
        MyContentView(loginUser: loginUser)
    }
}

#Preview {
    PreviewView()
}
