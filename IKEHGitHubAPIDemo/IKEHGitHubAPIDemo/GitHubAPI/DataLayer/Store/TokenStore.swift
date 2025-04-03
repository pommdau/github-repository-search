//
//  TokenStore.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/20.
//

import SwiftUI
import KeychainAccess

final actor TokenStore: TokenStoreProtocol {
        
    static var shared: TokenStore = .init()
    
    // MARK: - Property
                                
    var accessToken: String? {
        didSet {
            keychain[Keychain.Constant.Key.accessToken] = accessToken
        }
    }
        
    var accessTokenExpiresAt: Date? {
        didSet {
            userDefaults.set(accessTokenExpiresAt, forKey: "TokenStore.accessTokenExpiresAt")
        }
    }
    
    @MainActor var lastLoginStateID = ""
        
    private let keychain: Keychain
    private let userDefaults: UserDefaults
         
    // MARK: - LifeCycle
            
    init(
        keyChain: Keychain = Keychain(service: Keychain.Constant.Service.oauth),
        userDefaults: UserDefaults = .standard
    ) {
        // DI
        self.keychain = keyChain
        self.userDefaults = userDefaults
        
        // 保存値の復元
        self.accessToken = keychain[Keychain.Constant.Key.accessToken]
        self.accessTokenExpiresAt = userDefaults.value(forKey: "TokenStore.accessTokenExpiresAt") as? Date
    }
}
