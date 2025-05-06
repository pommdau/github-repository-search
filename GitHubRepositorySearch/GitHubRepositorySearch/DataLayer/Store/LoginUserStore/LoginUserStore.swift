//
//  LoginUserStore.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import Foundation
import IKEHGitHubAPIClient

@MainActor
@Observable
final class LoginUserStore: LoginUserStoreProtocol {
    
    // MARK: - Property
        
    static let shared: LoginUserStore = .init()
    
    let userDefaults: UserDefaults
//    let tokenStore: TokenStore
    let gitHubAPIClient: GitHubAPIClientProtocol

    var loginUser: LoginUser? {
        didSet {
            userDefaults.setCodableItem(loginUser, forKey: UserDefaults.Key.LoginUserStore.loginUser)
        }
    }
        
    // MARK: - LifeCycle

    init(
        userDefaults: UserDefaults = .standard,
        gitHubAPIClient: GitHubAPIClientProtocol = GitHubAPIClient.shared
    ) {
        self.userDefaults = userDefaults
        self.gitHubAPIClient = gitHubAPIClient
        // 保存されている情報が有れば読み込み
        self.loginUser = userDefaults.codableItem(forKey: UserDefaults.Key.LoginUserStore.loginUser)
    }
    
    // MARK: - GitHubAPI
    
    func fetchLoginUser() async throws {
//        gitHubAPIClient.fetchLoginUser(accessToken: <#T##String#>)
    }
}
