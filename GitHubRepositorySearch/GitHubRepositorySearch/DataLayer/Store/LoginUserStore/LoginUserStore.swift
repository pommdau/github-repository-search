//
//  LoginUserStore.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import SwiftUI
import IKEHGitHubAPIClient

@MainActor
@Observable
final class LoginUserStore: LoginUserStoreProtocol {
    
    // MARK: - Property
        
    static let shared: LoginUserStore = .init()
    
    let userDefaults: UserDefaults
    let tokenStore: TokenStoreProtocol
    let gitHubAPIClient: GitHubAPIClient

    var loginUser: LoginUser? {
        didSet {
            userDefaults.setCodableItem(loginUser, forKey: UserDefaults.Key.LoginUserStore.loginUser)
        }
    }
        
    // MARK: - LifeCycle

    init(
        userDefaults: UserDefaults = .standard,
        tokenStore: TokenStoreProtocol = TokenStore.shared,
        gitHubAPIClient: GitHubAPIClient = GitHubAPIClient.shared,
    ) {
        self.userDefaults = userDefaults
        self.tokenStore = tokenStore
        self.gitHubAPIClient = gitHubAPIClient
        // 保存されている情報が有れば読み込み
        self.loginUser = userDefaults.codableItem(forKey: UserDefaults.Key.LoginUserStore.loginUser)
    }
    
    // MARK: - GitHubAPI
    
    func fetchLoginUser() async throws {
        guard let accessToken = await tokenStore.accessToken else {
            return
        }        
        let loginUser = try await gitHubAPIClient.fetchLoginUser(accessToken: accessToken)
        withAnimation {
            self.loginUser = loginUser
        }
    }
}
