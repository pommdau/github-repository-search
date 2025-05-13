//
//  TokenStoreStub.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import Foundation
import KeychainAccess

final actor TokenStoreStub: TokenStoreProtocol {
    
    // MARK: - Property
    
    var accessToken: String?
    let keychain: Keychain? = nil // Stubではデータの永続化を行わないのでnil
    
    // MARK: - LifeCycle
    
    init(accessToken: String? = nil) {
        self.accessToken = accessToken
    }
        
    // MARK: - GitHubAPI
    
    func openLoginPageInBrowser() async throws {}
    
    func fetchAccessTokenWithCallbackURL(_ url: URL) async throws {}
    
    func logout() async throws {
        deleteValue()
    }
}
