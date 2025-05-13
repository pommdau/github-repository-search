//
//  LoginView.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import SwiftUI
import class IKEHGitHubAPIClient.GitHubAPIClient

struct LoginView: View {
    
    // MARK: - Property
            
    @State private var viewState: LoginViewState
    
    init(namespace: Namespace.ID? = nil) {
        _viewState = State(wrappedValue: LoginViewState(namespace: namespace))
    }
    
    /// Preview用のイニシャライザ
    fileprivate init(viewState: LoginViewState) {
        _viewState = State(wrappedValue: viewState)
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
            
            Button("Log in") {
                viewState.handleLoginButtonTapped()
            }
            .gitHubButtonStyle(.logIn)
            .padding(.bottom, 8)
            .matchedGeometryEffect(id: NamespaceID.LoginView.button1, in: viewState.namespace)
            
            Text("When you log in to GitHub, you can star repositories and browse a list of repositories you’ve starred.")
                .foregroundStyle(.secondary)
                .frame(width: 240)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

//#Preview {
//    let viewState = LoginViewState(
//        tokenStore: TokenStoreStub(),
//        loginUserStore: LoginUserStoreStub(),
//        namespace: nil,
//    )
//    LoginView(viewState: viewState)
//}
