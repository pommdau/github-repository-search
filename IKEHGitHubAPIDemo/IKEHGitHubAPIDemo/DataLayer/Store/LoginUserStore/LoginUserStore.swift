//
//  LoginUserStore.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation

@MainActor
@Observable
final class LoginUserStore: LoginUserStoreProtocol {
    
    static let shared: LoginUserStore = .init()
    
    let userDefaults: UserDefaults

    var loginUser: LoginUser? {
        didSet {
            UserDefaults.standard.setCodableItem(loginUser, forKey: "ikehgithubapi-login-user")
        }
    }
        
    // MARK: - LifeCycle

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        // 保存されている情報が有れば読み込み
        self.loginUser = userDefaults.codableItem(forKey: "ikehgithubapi-login-user")
    }
}
