//
//  TokenStoreStub.swift
//  IKEHGitHubAPIDemoTests
//
//  Created by HIROKI IKEUCHI on 2025/03/21.
//

import Foundation

final actor TokenStoreStub: TokenStoreProtocol {

    static var shared: TokenStoreStub = .init()
        
    // MARK: - Property
    
    var accessToken: String?
    var accessTokenExpiresAt: Date?
    @MainActor var lastLoginStateID: String = ""
    
    /// 初期化時、デフォルトでは有効な値をセットする
    init(
        accessToken: String? = UUID().uuidString,
        accessTokenExpiresAt: Date? = Calendar.current.date(byAdding: .year, value: 1, to: .now), // 1年後
        lastLoginStateID: String = UUID().uuidString
    ) {
        self.accessToken = accessToken
        self.accessTokenExpiresAt = accessTokenExpiresAt
        self.lastLoginStateID = lastLoginStateID
    }
}

// Test Methods

extension TokenStoreStub {
    func setValidRandomToken() {
        accessToken = UUID().uuidString
        accessTokenExpiresAt = Calendar.current.date(byAdding: .year, value: 1, to: .now) // 有効期限は一年
    }
}
