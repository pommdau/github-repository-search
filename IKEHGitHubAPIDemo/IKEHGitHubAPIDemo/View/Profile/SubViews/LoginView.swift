//
//  LoginView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//

import SwiftUI

struct NewLoginView: View {
    
    // MARK: - Property
        
    var namespace: Namespace.ID?
    var logInButtonTapped: () -> Void = {}
    
    // MARK: - View
    
    var body: some View {
        VStack {
            Image(.githubMark)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .matchedGeometryEffect(id: NamespaceID.LoginView.image1, in: namespace)
            
            Text("Log in to GitHub")
                .font(.title)
                .padding(.bottom, 60)
            
            Button("Log in") {
                logInButtonTapped()
            }
            .gitHubButtonStyle(.logIn)
            .padding(.bottom, 8)
            .matchedGeometryEffect(id: NamespaceID.LoginView.button1, in: namespace)
            
            Text("When you log in to GitHub, you can star repositories and browse a list of repositories you’ve starred.")
                .foregroundStyle(.secondary)
                .frame(width: 240)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NewLoginView()
}
