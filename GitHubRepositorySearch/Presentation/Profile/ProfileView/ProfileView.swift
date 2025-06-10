//
//  ProfileView.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import SwiftUI

// MARK: - ProfileView

struct ProfileView: View {
    
    @State private var state: ProfileViewState = .init()
    
    var body: some View {
        Content(isLoggedIn: state.isLoggedIn)
    }
}

// MARK: - Content

private extension ProfileView {
    
    struct Content: View {
        
        @Namespace var namespace
        let isLoggedIn: Bool
        
        var body: some View {
            VStack {
                if isLoggedIn {
                    LoginUserView(namespace: namespace)
                } else {
                    LoginView(namespace: namespace)
                }
            }
            .animation(.default, value: isLoggedIn)
        }
    }
}

// MARK: - Preview

private extension ProfileView {
    
    struct PreviewView: View {
        
        @State private var isLoggedIn = false
                
        var body: some View {
            ZStack {
                Toggle("Login: ", isOn: $isLoggedIn)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.blue.opacity(0.4))
                        .padding(-8)
                )
                .frame(width: 120)
                .offset(y: -300)
                .zIndex(1)

                ProfileView.Content(isLoggedIn: isLoggedIn)
            }
        }
    }
}

#Preview {
    ProfileView.PreviewView()
}
