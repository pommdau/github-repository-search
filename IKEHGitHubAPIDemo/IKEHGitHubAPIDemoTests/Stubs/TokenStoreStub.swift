//
//  TokenStoreStub.swift
//  IKEHGitHubAPIDemoTests
//
//  Created by HIROKI IKEUCHI on 2025/03/21.
//

import Foundation
@testable import IKEHGitHubAPIDemo

//protocol TokenStoreProtocol: Actor {
//    var accessToken: String? { get set }
//    var accessTokenExpiresAt: Date? { get set }
//    var isAccessTokenValid: Bool { get }
//    var lastLoginStateID: String { get set }
//
//    func updateTokens(accessToken: String?, accessTokenExpiresAt: Date?)
//    func updateLastLoginStateID(_ setLastLoginStateID: String)
//    func deleteAll()
//}

final actor TokenStoreStub: TokenStoreProtocol {
    var accessToken: String?
    
    var accessTokenExpiresAt: Date?
    
    var isAccessTokenValid: Bool = false
    
    @MainActor var lastLoginStateID: String = ""
    
    func updateTokens(accessToken: String?, accessTokenExpiresAt: Date?) {
        // TODO:
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
