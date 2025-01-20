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
    
    // TODO: keychainへの登録
    // TODO: Tokenクラスの定義
    
    @AppStorage("githubapi-access-token")
    var accessToken: String?
    
    @AppStorage("githubapi-access-token-expired-at")
    var accessTokenExpiredAt: Date?
    
    @AppStorage("githubapi-refresh-token")
    var refreshToken: String?
    
    @AppStorage("githubapi-refresh-token-expired-at")
    var refreshTokenExpiredAt: Date?
    
    var isAccessTokenValid: Bool {
        guard let _ = accessToken,
              let accessTokenExpiredAt else {
            return false
        }
        // トークンが有効期限内か
        return accessTokenExpiredAt.compare(.now) == .orderedDescending
    }
    
    var isRefreshTokenValid: Bool {
        guard let _ = refreshToken,
              let refreshTokenExpiredAt else {
            return false
        }
        // トークンが有効期限内か
        return refreshTokenExpiredAt.compare(.now) == .orderedDescending
    }
    
    // CRUD
    
    func set(
        accessToken: String? = nil,
        refreshToken: String? = nil,
        accessTokenExpiredAt: Date? = nil,
        refreshTokenExpiredAt: Date? = nil
    ) {
        if let accessToken = accessToken {
            self.accessToken = accessToken
        }
        if let refreshToken = refreshToken {
            self.refreshToken = refreshToken
        }
        if let accessTokenExpiredAt = accessTokenExpiredAt {
            self.accessTokenExpiredAt = accessTokenExpiredAt
        }
        if let refreshTokenExpiredAt = refreshTokenExpiredAt {
            self.refreshTokenExpiredAt = refreshTokenExpiredAt
        }
    }
}
