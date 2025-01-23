//
//  LoginView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//

import SwiftUI

struct LoginView: View {
    
    @State private var viewState: LoginViewState = .init()
            
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
        .alert("エラー", isPresented: $viewState.showAlert) {
            Button("OK") { }
        } message: {
            Text(viewState.alertError?.localizedDescription ?? "(不明なエラー)")
        }
        .onOpenURL { url in
            viewState.handleOnCallbackURL(url)
        }
    }
    
    @ViewBuilder
    private func loginButton() -> some View {
        Button("Log in") {
            viewState.handleLogInButtonTapped()
        }
        .buttonStyle(LogInButtonStyle())
        .padding(.bottom, 8)
    }
}

#Preview {
    LoginView()
}
