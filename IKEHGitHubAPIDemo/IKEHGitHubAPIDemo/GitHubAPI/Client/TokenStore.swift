//
//  TokenStore.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/20.
//

import Foundation
import SwiftUI

final actor TokenStore {
    
    static let shared: TokenStore = .init()

    // MARK: - Properties
    // TODO: keychainへの登録
    // TODO: Tokenクラスの定義
    @AppStorage("ikehgithubapi-access-token")
    var accessToken: String?
    
    @AppStorage("ikehgithubapi-access-token-expires-at")
    var accessTokenExpiresAt: Date?
    
    @AppStorage("ikehgithubapi-refresh-token")
    var refreshToken: String?
    
    @AppStorage("ikehgithubapi-refresh-token-expires-at")
    var refreshTokenExpiresAt: Date?
    
    var isLoggedIn: Bool {
        return refreshToken != nil // リフレッシュトークンの有無でログイン状態を判断する
    }
    
    // MARK: - LifeCycle
    
    private init() {}
    
    // MARK: - Validation
    
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
    
    // MARK: - Delete
    
    func removeAll() {
        accessToken = nil
        accessTokenExpiresAt = nil
        refreshToken = nil
        refreshTokenExpiresAt = nil
    }
}
