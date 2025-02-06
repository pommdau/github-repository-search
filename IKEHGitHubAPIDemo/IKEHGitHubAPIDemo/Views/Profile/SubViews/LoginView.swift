//
//  LoginView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//

import SwiftUI

@MainActor @Observable
final class LoginViewState {
    
    // MARK: - Property
        
    let namespace: Namespace.ID?
    let loginUserStore: LoginUserStore
    let githubAPIClient: GitHubAPIClient
    var error: Error?

    // MARK: - LifeCycle
    
    init(
        namespace: Namespace.ID? = nil,
        loginUserStore: LoginUserStore = .shared,
        githubAPIClient: GitHubAPIClient = .shared
    ) {
        self.namespace = namespace
        self.loginUserStore = loginUserStore
        self.githubAPIClient = githubAPIClient
    }
    
    // MARK: - Action
    
    func handleLogInButtonTapped() {
        Task {
            do {
                try await githubAPIClient.openLoginPageInBrowser()
            } catch {
                self.error = error
            }
        }
    }
}

struct NewLoginView: View {
        
    @State private var state: LoginViewState
    
    init(namespace: Namespace.ID? = nil) {
        _state = .init(wrappedValue: LoginViewState(namespace: namespace))
    }
    
    var body: some View {
        VStack {
            Image(.githubMark)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .matchedGeometryEffect(id: NamespaceID.ProfileView.image1, in: state.namespace)
            
            Text("Log in to GitHub")
                .font(.title)
                .padding(.bottom, 60)
            
            Button("Log in") {
                state.handleLogInButtonTapped()
            }
            .gitHubButtonStyle(.logIn)
            .padding(.bottom, 8)
            .matchedGeometryEffect(id: NamespaceID.ProfileView.button1, in: state.namespace)
            
            Text("When you log in to GitHub, you can star repositories and browse a list of repositories you’ve starred.")
                .foregroundStyle(.secondary)
                .frame(width: 240)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    @Previewable @Namespace var namespace
    NewLoginView(namespace: namespace)
}
