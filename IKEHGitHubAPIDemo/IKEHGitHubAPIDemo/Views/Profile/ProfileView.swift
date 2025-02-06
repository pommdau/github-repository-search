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
            Content(loginUser: state.loginUser)
        }
    }
}

private struct Content: View {
    
    @Namespace var namespace
    let loginUser: LoginUser?
    
    var body: some View {
        if let loginUser {
            LoginUserView(loginUser: loginUser, namespace: namespace)
        } else {
            NewLoginView(namespace: namespace)
        }
    }
}

// MARK: - Preview

private struct PreviewView: View {
    
    @State var loginUser: LoginUser?
    
    var body: some View {
        VStack {
            Button("Toggle") {
                withAnimation {
                    loginUser = (loginUser == nil) ? LoginUser.Mock.ikeh : nil
                }
            }
            Content(loginUser: loginUser)
        }
    }
}

#Preview {
    PreviewView()
}
