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
                
                Button("Is Starred") {
                    Task {
                        do {                            
                            let isStarred = try await gitHubAPIClient.checkIsRepoStarred(ownerName: "koher", repoName: "swift-id")
                            print(isStarred ? "starred" : "not starred")
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
                
                Button("Print") {
                    print(accessToken)
                }
                .frame(maxWidth: .infinity, alignment: .center)
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
            accessTokenExpiresAt = DateFormatter.tokenExpiresIn.string(from: accessTokenExpiresAtDate)
        } else {
            accessTokenExpiresAt = "(nil)"
        }
    }
}

#Preview {
    LoginDebugView()
}
