//
//  TokenStore.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/20.
//

import Foundation
import SwiftUI
import KeychainAccess

enum KeychainConstant {
    
    enum Service {
        static let oauth = "com.ikehgithubapi.oauth"
    }
    
    enum Key {
        static let accessToken = "ikehgithubapi-access-token"
        static let refreshToken = "ikehgithubapi-refresh-token"
    }
}

final actor TokenStore {
    
    static let shared: TokenStore = .init()
    
    // MARK: - Property
    
    let keychain = Keychain(service: KeychainConstant.Service.oauth)
    
    // 最新のログインセッションID
    @MainActor
    @AppStorage("ikehgithubapi-last-login-state-id")
    var lastLoginStateID: String = ""

    var accessToken: String? {
        didSet {
            keychain[KeychainConstant.Key.accessToken] = accessToken
        }
    }
    
    var refreshToken: String? {
        didSet {
            keychain[KeychainConstant.Key.refreshToken] = refreshToken
        }
    }
    
    @AppStorage("ikehgithubapi-access-token-expires-at")
    var accessTokenExpiresAt: Date? 
        
    @AppStorage("ikehgithubapi-refresh-token-expires-at")
    var refreshTokenExpiresAt: Date?
    
    // MARK: - Computed Properry
    
    var isAccessTokenValid: Bool {
        guard let _ = accessToken,
              let accessTokenExpiresAt else {
            return false
        }
        // トークンが有効期限内か
        return accessTokenExpiresAt.compare(.now) == .orderedDescending
    }
    
    var isRefreshTokenValid: Bool {
        guard let _ = refreshToken,
              let refreshTokenExpiresAt else {
            return false
        }
        // トークンが有効期限内か
        return refreshTokenExpiresAt.compare(.now) == .orderedDescending
    }
    
    /// ログインしているかどうか(リフレッシュトークンの有無で判断)
    var isLoggedIn: Bool {
        return refreshToken != nil
    }
    
    // MARK: - LifeCycle
    
    private init() {
        // 保存されている値の読込
        self.accessToken = keychain[KeychainConstant.Key.accessToken]
        self.refreshToken = keychain[KeychainConstant.Key.refreshToken]
        print(accessToken, refreshToken)
        print("stop")
    }
}

// MARK: - CRUD

extension TokenStore {
    
    // MARK: Update
    
    func set(
        accessToken: String? = nil,
        refreshToken: String? = nil,
        accessTokenExpiresAt: Date? = nil,
        refreshTokenExpiresAt: Date? = nil
    ) {
        if let accessToken = accessToken {
            self.accessToken = accessToken
        }
        if let refreshToken = refreshToken {
            self.refreshToken = refreshToken
        }
        if let accessTokenExpiresAt = accessTokenExpiresAt {
            self.accessTokenExpiresAt = accessTokenExpiresAt
        }
        if let refreshTokenExpiresAt = refreshTokenExpiresAt {
            self.refreshTokenExpiresAt = refreshTokenExpiresAt
        }
    }
    
    @MainActor
    func setLastLoginStateID(_ setLastLoginStateID: String) {
        self.lastLoginStateID = setLastLoginStateID
    }
    
    // MARK: - Delete
    
    func removeAll() {
        accessToken = nil
        accessTokenExpiresAt = nil
        refreshToken = nil
        refreshTokenExpiresAt = nil
    }
}
