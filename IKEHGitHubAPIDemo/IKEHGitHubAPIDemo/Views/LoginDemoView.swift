//
//  LoginDemoView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/20.
//

import SwiftUI


struct LoginDemoView: View {
    
    @State private var accessToken = "(nil)"
    @State private var accessTokenExpiresAt = "(nil)"
    @State private var refreshToken = "(nil)"
    @State private var refreshTokenExpiresAt = "(nil)"
                
    var body: some View {
        Form {
            LabeledContent("Access Token") {
                VStack(alignment: .trailing) {
                    Text(accessToken)
                        .lineLimit(1)
                    Text(accessTokenExpiresAt)
                }
            }
            LabeledContent("Refresh Token") {
                VStack(alignment: .trailing) {
                    Text(refreshToken)
                        .lineLimit(1)
                    Text(refreshTokenExpiresAt)
                }
            }
            Button("Update") {
                Task {
                    await loadTokens()
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .onAppear() {
            Task {
                await loadTokens()
            }
        }
    }
    
    private func loadTokens() async {
        accessToken = await GitHubAPIClient.shared.tokenManager.accessToken ?? "(nil)"
        if let accessTokenExpiresAtDate = await GitHubAPIClient.shared.tokenManager.accessTokenExpiredAt {
            accessTokenExpiresAt = DateFormatter.forTokenCheck.string(from: accessTokenExpiresAtDate)
        } else {
            accessTokenExpiresAt = "(nil)"
        }
        refreshToken = await GitHubAPIClient.shared.tokenManager.refreshToken ?? "(nil)"
        if let refreshTokenExpiredAtDate = await GitHubAPIClient.shared.tokenManager.refreshTokenExpiredAt {
            refreshTokenExpiresAt = DateFormatter.forTokenCheck.string(from: refreshTokenExpiredAtDate)
        } else {
            refreshTokenExpiresAt = "(nil)"
        }
    }
}

#Preview {
    LoginDemoView()
}
