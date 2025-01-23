//
//  LoginView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//

import SwiftUI



struct LoginView: View {
    
    private let gitHubAPIClient: GitHubAPIClient
    private let loginUserStore: LoginUserStore
    
    init(
        gitHubAPIClient: GitHubAPIClient = .shared,
        loginUserStore: LoginUserStore = .shared
    ) {
        self.gitHubAPIClient = gitHubAPIClient
        self.loginUserStore = loginUserStore
    }
    
    var body: some View {
        VStack {
            Image(.githubMark)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Text("Log in to GitHub")
                .font(.title)
                .padding(.bottom, 60)
            
            loginButton()
            
            Text("When you log in to GitHub, you can star repositories and browse a list of repositories you’ve starred.")
                .foregroundStyle(.secondary)
                .frame(width: 240)
        }
        .frame(maxWidth: .infinity)
        .onOpenURL { (url) in
            Task {
                let sessionCode = try await gitHubAPIClient.extactSessionCodeFromCallbackURL(url)
                do {
                    try await gitHubAPIClient.fetchInitialToken(sessionCode: sessionCode)
                    print("ログイン成功！")
                    let loginUser = try await gitHubAPIClient.fetchLoginUser()
                    loginUserStore.save(loginUser)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension LoginView {
    @ViewBuilder
    private func loginButton() -> some View {
        Button("Log in") {
            Task {
                do {
                    try await gitHubAPIClient.openLoginPageInBrowser()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .buttonStyle(LogInButtonStyle())
        .padding(.bottom, 8)
    }
}

#Preview {
    LoginView()
}
