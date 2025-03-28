//
//  TokenStore.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/20.
//

import SwiftUI
import KeychainAccess

protocol TokenStoreProtocol: Actor {
    var accessToken: String? { get set }
    var accessTokenExpiresAt: Date? { get set }
    var isAccessTokenValid: Bool { get }
    @MainActor var lastLoginStateID: String { get set }
    
    func updateTokens(accessToken: String?, accessTokenExpiresAt: Date?)
    @MainActor
    func updateLastLoginStateID(_ setLastLoginStateID: String)
    func deleteAll()
}

final actor TokenStore: TokenStoreProtocol {
                
    /// シングルトン用インスタンス
    static let shared: TokenStore = .init()
        
    // MARK: - Property(Public)
    
    /// アクセストークン
    var accessToken: String? {
        didSet {
            keychain[Keychain.Constant.Key.accessToken] = accessToken
        }
    }
    
    /// アクセストークンの有効期限(1年間)
    var accessTokenExpiresAt: Date? {
        didSet {
            userDefaults.set(accessTokenExpiresAt, forKey: "TokenStore.accessTokenExpiresAt")
        }
    }
    
    /// 最後のログインセッションID
    @MainActor var lastLoginStateID = ""
    
    // MARK: - Property(Private)
    
    private let keychain: Keychain
    private let userDefaults: UserDefaults
     
    /// 有効なアクセストークンがあるかどうか
    var isAccessTokenValid: Bool {
        if accessToken != nil,
           let accessTokenExpiresAt {
            return accessTokenExpiresAt.compare(.now) == .orderedDescending // トークンが有効期限内か
        }
        
        return false
    }
    
    // MARK: - LifeCycle
            
    init(
        keyChain: Keychain = Keychain(service: Keychain.Constant.Service.oauth),
        userDefaults: UserDefaults = .standard
    ) {
        // DI
        self.keychain = keyChain
        self.userDefaults = userDefaults
        
        // 保存値の復元
        self.accessToken = self.keychain[Keychain.Constant.Key.accessToken]
        self.accessTokenExpiresAt = self.userDefaults.value(forKey: "TokenStore.accessTokenExpiresAt") as? Date
    }
}

// MARK: - CRUD

extension TokenStore {
    
    // MARK: Create/Update
    
    func updateTokens(
        accessToken: String? = nil,
        accessTokenExpiresAt: Date? = nil
    ) {
        if let accessToken = accessToken {
            self.accessToken = accessToken
        }
        if let accessTokenExpiresAt = accessTokenExpiresAt {
            self.accessTokenExpiresAt = accessTokenExpiresAt
        }
    }
    
    @MainActor
    func updateLastLoginStateID(_ setLastLoginStateID: String) {
        self.lastLoginStateID = setLastLoginStateID
    }
    
    // MARK: - Delete
    
    func deleteAll() {
        accessToken = nil
        accessTokenExpiresAt = nil
    }
}
