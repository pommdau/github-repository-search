//
//  ContentView.swift
//  IKEHGitHubAPI
//
//  Created by HIROKI IKEUCHI on 2025/04/10.
//

import SwiftUI
import GitHubAPIClient
import Dependencies

// MARK: - ViewState

@MainActor
@Observable
final class LoginViewState {
    
    let gitHubAPIClient: GitHubAPIClientProtocol
    let tokenStore: TokenStoreProtocol
    
    var accessToken: String = "" // 表示用
    var error: Error?
    
    init() {
        /// https://github.com/pointfreeco/swift-dependencies/discussions/99#discussioncomment-6110677
        @Dependency(\.gitHubAPIClient)
        var gitHubAPIClient
        self.gitHubAPIClient = gitHubAPIClient
        
        @Dependency(\.tokenStore)
        var tokenStore
        self.tokenStore = tokenStore
    }
    
    // MARK: - Actions
    
    /// ログインボタンが押された
    func handleLoginButtonTapped() async {
        do {
            try await gitHubAPIClient.openLoginPageInBrowser()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func handleOnCallbackURL(_ url: URL) async {
        do {
            let accessToken = try await gitHubAPIClient.handleLoginCallBackURLAndFetchAccessToken(url)
            
            self.accessToken = accessToken
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func handleLogoutButtonTapped() async {
        guard let accessToken = await tokenStore.accessToken else {
            return
        }
        do {
            try await gitHubAPIClient.logout(accessToken: accessToken)
        } catch {
            print(error.localizedDescription)
        }
        // ローカル上の認証情報の削除
        // サーバ上の認証情報の削除に失敗した場合もローカルのトークン情報を削除する
        await tokenStore.deleteAll()
        self.accessToken = ""
    }
}

// MARK: - View

struct ContentView: View {
    
    @State private var state: LoginViewState = .init()
    
    var body: some View {
        
        Form {
            Section("Authorize") {
                LabeledContent("AccessToken", value: state.accessToken)
                LabeledContent("Error", value: state.error?.localizedDescription ?? "(nil)")
                ZStack {
                    if state.accessToken.isEmpty {
                        Button("Log in") {
                            Task {
                                await state.handleLoginButtonTapped()
                            }
                        }
                    } else {
                        Button("Log out", role: .destructive) {
                            Task {
                                await state.handleLogoutButtonTapped()
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .onOpenURL { url in
            Task {
                await state.handleOnCallbackURL(url)
            }
        }
    }
}

#Preview {
    ContentView()
}
