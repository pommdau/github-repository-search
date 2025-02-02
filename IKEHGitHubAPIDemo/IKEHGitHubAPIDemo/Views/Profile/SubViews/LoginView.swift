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
            
    let loginUserStore: LoginUserStore
    let githubAPIClient: GitHubAPIClient
    var error: Error?
    
    // MARK: - LifeCycle
    
    init(loginUserStore: LoginUserStore = .shared, githubAPIClient: GitHubAPIClient = .shared) {
        self.loginUserStore = loginUserStore
        self.githubAPIClient = githubAPIClient
    }
    
    // MARK: - Actions
    
    func handleOnCallbackURL(_ url: URL) {
        Task {
            do {
                let loginUser = try await githubAPIClient.handleLoginCallBackURL(url)
                print("ログイン成功！")
                withAnimation {
                    loginUserStore.addValue(loginUser)
                }
            } catch {
                print(error.localizedDescription)
                self.error = error
            }
        }
    }
    
    func handleLogInButtonTapped() {
        Task {
            do {
                try await githubAPIClient.openLoginPageInBrowser()
            } catch {
                print(error.localizedDescription)
                self.error = error
            }
        }
    }
}

struct LoginView: View {
    
    let namespace: Namespace.ID
    @State private var state: LoginViewState = .init()
                    
    var body: some View {
        VStack {
            Image(.githubMark)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .matchedGeometryEffect(id: ProfileView.NamespaceID.image1, in: namespace)
            
            Text("Log in to GitHub")
                .font(.title)
                .padding(.bottom, 60)
            
            Button("Log in") {
                state.handleLogInButtonTapped()
            }
            .buttonStyle(LogInButtonStyle())
            .padding(.bottom, 8)
            .matchedGeometryEffect(id: ProfileView.NamespaceID.button1, in: namespace)
            
            Text("When you log in to GitHub, you can star repositories and browse a list of repositories you’ve starred.")
                .foregroundStyle(.secondary)
                .frame(width: 240)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    @Previewable @Namespace var namespace
    LoginView(namespace: namespace)
}
