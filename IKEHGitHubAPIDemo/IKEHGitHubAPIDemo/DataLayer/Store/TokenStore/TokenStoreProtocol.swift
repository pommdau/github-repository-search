//
//  TokenStoreProtocol.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/04/03.
//

import Foundation

protocol TokenStoreProtocol: Actor {
    static var shared: Self { get } // シングルトン
    
    var accessToken: String? { get set } // アクセストークン
    var accessTokenExpiresAt: Date? { get set } // アクセストークンの有効期限(作成後1年間)
    @MainActor var lastLoginStateID: String { get set } // 最後のログインセッションID

}

extension TokenStoreProtocol {
    
    // MARK: - Property
    
    /// 有効なアクセストークンがあるかどうか
    var isAccessTokenValid: Bool {
        if accessToken != nil,
           let accessTokenExpiresAt {
            return accessTokenExpiresAt.compare(.now) == .orderedDescending // トークンが有効期限内か
        }
        
        return false
    }
    
    // MARK: - CRUD
    
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
    
    func deleteAll() {
        accessToken = nil
        accessTokenExpiresAt = nil
    }
}
