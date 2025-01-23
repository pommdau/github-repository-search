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
    
    var realAccessToken: String? {
        gitHubAPIClient.tokenStore.accessToken
    }
    
    private let gitHubAPIClient: GitHubAPIClient
    
    init(gitHubAPIClient: GitHubAPIClient = GitHubAPIClient.shared) {
        self.gitHubAPIClient = gitHubAPIClient
    }
            
    var body: some View {
        Form {
            Section("Action") {
                Button("Log in") {
                    Task {
                        do {
                            try await gitHubAPIClient.openLoginPageInBrowser()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Button("Update Access Token") {
                    Task {
                        do {
                            try await gitHubAPIClient.updateAccessTokenIfNeeded(forceUpdate: true)
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
                            try await gitHubAPIClient.logout()
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
                            let response = try await gitHubAPIClient.searchRepos(searchText: "swiftui")
                            let repos = response.items
                            print(repos.count)
                            await loadTokens()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Button("Fetch LoginUser") {
                    Task {
                        do {
                            let loginUser = try await gitHubAPIClient.fetchLoginUser()
                            print("stop")
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
                let sessionCode = try await gitHubAPIClient.extactSessionCodeFromCallbackURL(url)
                do {
                    try await gitHubAPIClient.fetchInitialToken(sessionCode: sessionCode)
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
        accessToken = await gitHubAPIClient.tokenStore.accessToken ?? "(nil)"
        if let accessTokenExpiresAtDate = await gitHubAPIClient.tokenStore.accessTokenExpiresAt {
            accessTokenExpiresAt = DateFormatter.forTokenExpiresIn.string(from: accessTokenExpiresAtDate)
        } else {
            accessTokenExpiresAt = "(nil)"
        }
        refreshToken = await gitHubAPIClient.tokenStore.refreshToken ?? "(nil)"
        if let refreshTokenExpiresAtDate = await gitHubAPIClient.tokenStore.refreshTokenExpiresAt {
            refreshTokenExpiresAt = DateFormatter.forTokenExpiresIn.string(from: refreshTokenExpiresAtDate)
        } else {
            refreshTokenExpiresAt = "(nil)"
        }
    }
}

#Preview {
    LoginDebugView()
}
