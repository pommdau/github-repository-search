//
//  LoginUserStore.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import Foundation
import struct IKEHGitHubAPIClient.LoginUser

@MainActor
@Observable
final class LoginUserStore: LoginUserStoreProtocol {
    
    static let shared: LoginUserStore = .init()
    
    let userDefaults: UserDefaults

    var loginUser: LoginUser? {
        didSet {
            userDefaults.setCodableItem(loginUser, forKey: UserDefaults.Key.LoginUserStore.loginUser)
        }
    }
        
    // MARK: - LifeCycle

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        // 保存されている情報が有れば読み込み
        self.loginUser = userDefaults.codableItem(forKey: UserDefaults.Key.LoginUserStore.loginUser)
    }
}
