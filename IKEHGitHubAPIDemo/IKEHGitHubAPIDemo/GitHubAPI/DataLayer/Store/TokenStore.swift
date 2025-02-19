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
    }
}

final actor TokenStore {
    
    static let shared: TokenStore = .init()
        
    // MARK: - Property
    
    let keychain = Keychain(service: KeychainConstant.Service.oauth)
    
    // 最新のログインセッションID
    @AppStorage("ikehgithubapi-last-login-state-id") 
    @MainActor var lastLoginStateID: String = ""

    var accessToken: String? {
        didSet {
            keychain[KeychainConstant.Key.accessToken] = accessToken
        }
    }
    
    @AppStorage("ikehgithubapi-access-token-expires-at")
    var accessTokenExpiresAt: Date?
    
    // 認証ユーザの情報をAPIで利用する場合があるため、ここのプロパティで管理する
    var loginUser: LoginUser? {
        didSet {
            UserDefaults.standard.setCodableItem(loginUser, forKey: "ikehgithubapi-login-user")
        }
    }
    
    // MARK: - Computed Properry
    
    /// 有効なアクセストークンがあるか
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
        self.accessToken = keychain[KeychainConstant.Key.accessToken]
        self.loginUser = UserDefaults.standard.codableItem(forKey: "ikehgithubapi-login-user")
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
    func addLastLoginStateID(_ setLastLoginStateID: String) {
        self.lastLoginStateID = setLastLoginStateID
    }
    
    // MARK: - Delete
    
    func deleteAll() {
        accessToken = nil
        accessTokenExpiresAt = nil
    }
}
