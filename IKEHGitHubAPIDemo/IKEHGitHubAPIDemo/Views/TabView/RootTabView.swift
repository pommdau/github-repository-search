//
//  RootTabView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

@MainActor @Observable
final class RootTabViewState {
    
    // MARK: - Property
        
    let loginUserStore: LoginUserStore
    let githubAPIClient: GitHubAPIClient
    var error: Error?

    // MARK: - LifeCycle
    
    init(
        loginUserStore: LoginUserStore = .shared,
        githubAPIClient: GitHubAPIClient = .shared
    ) {
        self.loginUserStore = loginUserStore
        self.githubAPIClient = githubAPIClient
    }
    
    // MARK: - Action
    
    func handleOnCallbackURL(_ url: URL) {
        Task {
            do {
                let loginUser = try await githubAPIClient.handleLoginCallBackURL(url)
                withAnimation {
                    loginUserStore.addValue(loginUser)
                }
            } catch {
                self.error = error
            }
        }
    }
}

struct RootTabView: View {
    
    @AppStorage("roottabview-selected-tab")
    private var selectedTab: TabType = .profile
    
    @State private var state: RootTabViewState = .init()
        
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(TabType.profile.title, systemImage: TabType.profile.icon, value: TabType.profile) {
                ProfileView()
            }

            Tab(TabType.search.title, systemImage: TabType.search.icon, value: TabType.search) {
                SearchScreen()
            }
            
            Tab(TabType.starredRepos.title, systemImage: TabType.starredRepos.icon, value: TabType.starredRepos) {
                StarredReposView()
            }
            
            Tab(TabType.debug.title, systemImage: TabType.debug.icon, value: TabType.debug) {
                LoginDebugView()
            }
        }
        .onOpenURL { url in
            state.handleOnCallbackURL(url)
        }
    }
}

#Preview {
    RootTabView()
}
