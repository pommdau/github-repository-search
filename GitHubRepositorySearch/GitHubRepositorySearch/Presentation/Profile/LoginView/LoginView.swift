//
//  LoginView.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import SwiftUI

struct LoginView: View {
    
    // MARK: - Property
            
    @State private var viewState: LoginViewState
    
    // MARK: - LifeCycle
    
    // swiftlint:disable:next type_contents_order
    init(namespace: Namespace.ID? = nil) {
        _viewState = State(wrappedValue: LoginViewState(namespace: namespace))
    }
    
    // MARK: - View
    
    var body: some View {
        VStack {
            Image(.githubMark)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .matchedGeometryEffect(id: NamespaceID.LoginView.image1, in: viewState.namespace)
                .accessibilityLabel(Text("GitHub icon"))
            Text("Log in to GitHub")
                .font(.title)
                .padding(.bottom, 60)
            loginButton()
            Text("When you log in to GitHub, you can star repositories and browse a list of repositories you’ve starred.")
                .foregroundStyle(.secondary)
                .frame(width: 240)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - UI Components
    
    @ViewBuilder
    private func loginButton() -> some View {
        
        if ProcessInfo.processInfo.environment["ENABLE_DUMMY_API"] == "true" {
            Button("Log in (ダミーユーザ)") {
                Task {
                    await TokenStore.shared.addValue("dummy_access_token")
                    LoginUserStore.shared.addValue(.Mock.ikeh)
                }
            }
            .gitHubButtonStyle(.logIn)
            .padding(.bottom, 8)
            .matchedGeometryEffect(id: NamespaceID.LoginView.button1, in: viewState.namespace)
        } else {
            Button("Log in") {
                viewState.handleLoginButtonTapped()
            }
            .gitHubButtonStyle(.logIn)
            .padding(.bottom, 8)
            .matchedGeometryEffect(id: NamespaceID.LoginView.button1, in: viewState.namespace)
        }
    }
}

// MARK: - Preview

#Preview {
    LoginView()
}
