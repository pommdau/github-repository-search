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
        Content(loginUser: state.loginUser)
    }
}

extension ProfileView {
    fileprivate struct Content: View {
        
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
}

// MARK: - Preview

private struct PreviewView: View {
    
    @State var loginUser: LoginUser?
    
    var body: some View {
        ZStack {
            Button("Toggle") {
                withAnimation {
                    loginUser = (loginUser == nil) ? LoginUser.Mock.ikeh : nil
                }
            }
            .gitHubButtonStyle(.logIn)
            .offset(y: -300)
            
            ProfileView.Content(loginUser: loginUser)
        }
    }
}

#Preview {
    PreviewView()
}
