//
//  TokenStoreStub.swift
//  IKEHGitHubAPIDemoTests
//
//  Created by HIROKI IKEUCHI on 2025/03/21.
//

import Foundation
@testable import IKEHGitHubAPIDemo

final actor TokenStoreStub: TokenStoreProtocol {
    
    // MARK: - Property
    
    var accessToken: String?
    
    var accessTokenExpiresAt: Date?
    
    var isAccessTokenValid: Bool = false
    
    @MainActor var lastLoginStateID: String = ""
            
    // MARK: - CRUD
    
    func updateTokens(accessToken: String?, accessTokenExpiresAt: Date?) {
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

// Test Methods

extension TokenStoreStub {
    func setValidRandomToken() {
        accessToken = UUID().uuidString
        accessTokenExpiresAt = Calendar.current.date(byAdding: .year, value: 1, to: .now) // 有効期限は一年
        isAccessTokenValid = true
    }
}
