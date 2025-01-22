//
//  LoginDemoView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/20.
//

import SwiftUI


struct LoginDebugView: View {
    
    @State private var accessToken = "(nil)"
    @State private var accessTokenExpiresAt = "(nil)"
    @State private var refreshToken = "(nil)"
    @State private var refreshTokenExpiresAt = "(nil)"
                
    var body: some View {
        Form {
            Section("Action") {
                Button("Log in") {
                    Task {
                        do {
                            try await GitHubAPIClient.shared.openLoginPage()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Button("Update Access Token") {
                    Task {
                        do {
                            try await GitHubAPIClient.shared.updateAccessTokenIfNeeded(forceUpdate: true)
                            await loadTokens()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Button("Log out", role: .destructive) {
                    Task {
                        do {
                            try await GitHubAPIClient.shared.logout()
                            await loadTokens()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Button("Search Repos") {
                    Task {
                        do {
                            let response = try await GitHubAPIClient.shared.searchRepos(searchText: "swiftui")
                            let repos = response.items
                            print(repos.count)
                            await loadTokens()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Section("Access Token") {
                LabeledContent("Value", value: accessToken)
                LabeledContent("Expires in", value: accessTokenExpiresAt)
            }
            
            Section("Refresh Token") {
                LabeledContent("Value", value: refreshToken)
                LabeledContent("Expires in", value: refreshTokenExpiresAt)
            }
        }
        .onOpenURL { (url) in
            Task {
                let sessionCode = try GitHubAPIClient.shared.handleLoginCallbackURL(url)
                do {
                    try await GitHubAPIClient.shared.fetchFirstToken(sessionCode: sessionCode)
                    await loadTokens()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .onAppear() {
            Task {
                await loadTokens()
            }
        }
    }
    
    private func loadTokens() async {
        accessToken = await GitHubAPIClient.shared.tokenStore.accessToken ?? "(nil)"
        if let accessTokenExpiresAtDate = await GitHubAPIClient.shared.tokenStore.accessTokenExpiresAt {
            accessTokenExpiresAt = DateFormatter.forTokenCheck.string(from: accessTokenExpiresAtDate)
        } else {
            accessTokenExpiresAt = "(nil)"
        }
        refreshToken = await GitHubAPIClient.shared.tokenStore.refreshToken ?? "(nil)"
        if let refreshTokenExpiresAtDate = await GitHubAPIClient.shared.tokenStore.refreshTokenExpiresAt {
            refreshTokenExpiresAt = DateFormatter.forTokenCheck.string(from: refreshTokenExpiresAtDate)
        } else {
            refreshTokenExpiresAt = "(nil)"
        }
    }
}

#Preview {
    LoginDebugView()
}
