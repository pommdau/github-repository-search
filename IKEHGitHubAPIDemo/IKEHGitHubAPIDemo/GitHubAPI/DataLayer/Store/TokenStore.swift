//
//  TokenStore.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/20.
//

import SwiftUI
import KeychainAccess

protocol TokenStoreProtocol {
    static var shared: Self { get }
    var accessToken: String? { get set }
    var accessTokenExpiresAt: Date? { get set }
    var lastLoginStateID: String { get set }
    func updateTokens(accessToken: String?, accessTokenExpiresAt: Date?)
    func updateLastLoginStateID(_ setLastLoginStateID: String)
    func deleteAll()
}

final actor TokenStore {
    
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
    @AppStorage("ikehgithubapi-access-token-expires-at")
    var accessTokenExpiresAt: Date?
    
    /// 最後のログインセッションID
    @AppStorage("ikehgithubapi-last-login-state-id")
    @MainActor var lastLoginStateID: String = ""
    
    // MARK: - Property(Private)
    
    private let keychain = Keychain(service: Keychain.Constant.Service.oauth)
    
    /// 有効なアクセストークンがあるかどうか
    var isAccessTokenValid: Bool {
        if accessToken != nil,
           let accessTokenExpiresAt {
            return accessTokenExpiresAt.compare(.now) == .orderedDescending // トークンが有効期限内か
        }
        
        return false
    }
    
    // MARK: - LifeCycle
    
    private init() {
        // 保存されている値の読込
        self.accessToken = keychain[Keychain.Constant.Key.accessToken]
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
