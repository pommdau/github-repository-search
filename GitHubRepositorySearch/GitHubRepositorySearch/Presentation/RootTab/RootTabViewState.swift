//
//  RootTabViewState.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/19.
//

import SwiftUI
import IKEHGitHubAPIClient

@MainActor
@Observable
final class RootTabViewState {
    
    // MARK: - Property
        
    let tokenStore: TokenStoreProtocol
    let loginUserStore: LoginUserStoreProtocol
    
    /// 選択中のタブ
    var selectedTab: RootTabType {
        didSet {
            UserDefaults.standard.set(selectedTab.rawValue, forKey: UserDefaults.Key.RootTabViewState.selectedTab)
        }
    }
    
    var error: Error?

    // MARK: - LifeCycle
    
    init(
        tokenStore: TokenStoreProtocol = TokenStore.shared,
        loginUserStore: LoginUserStoreProtocol = LoginUserStore.shared,
    ) {
        self.tokenStore = tokenStore
        self.loginUserStore = loginUserStore
        
        if let selectedTabRawValue = UserDefaults.standard.string(forKey: UserDefaults.Key.RootTabViewState.selectedTab),
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
                try await tokenStore.fetchAccessTokenWithCallbackURL(url)
                try await loginUserStore.fetchLoginUser()
            } catch {
                self.error = error
            }
        }
    }
}
