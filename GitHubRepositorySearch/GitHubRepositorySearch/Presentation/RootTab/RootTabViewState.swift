//
//  RootTabViewState.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/19.
//

import SwiftUI

@MainActor
@Observable
final class RootTabViewState {
    
    // MARK: - Property
        
//    let loginUserStore: LoginUserStore
//    let githubAPIClient: GitHubAPIClient
    
    /// 選択中のタブ
    var selectedTab: RootTabType {
        didSet {
            UserDefaults.standard.set(selectedTab.rawValue, forKey: "RootTabViewState.selectedTab")
        }
    }
    
    var error: Error?

    // MARK: - LifeCycle
    
    init(
//        loginUserStore: LoginUserStore = .shared,
//        githubAPIClient: GitHubAPIClient = .shared
    ) {
//        self.loginUserStore = loginUserStore
//        self.githubAPIClient = githubAPIClient
        
        if let selectedTabRawValue = UserDefaults.standard.string(forKey: "RootTabViewState.selectedTab"),
           let selectedTab = RootTabType(rawValue: selectedTabRawValue) {
            self.selectedTab = selectedTab
        } else {
            self.selectedTab = .profile
        }
    }
    
    // MARK: - Action
    
    func handleOnCallbackURL(_ url: URL) {
        Task {
            do {
//                try await githubAPIClient.handleLoginCallBackURL(url)
//                let loginUser = try await githubAPIClient.fetchLoginUser()                
                withAnimation {
//                    loginUserStore.addValue(loginUser)
                }
            } catch {
                self.error = error
            }
        }
    }
}
