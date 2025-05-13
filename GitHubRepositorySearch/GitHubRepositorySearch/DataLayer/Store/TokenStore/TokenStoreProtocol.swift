//
//  TokenStoreProtocol.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import Foundation
import KeychainAccess

protocol TokenStoreProtocol: Actor {

    // MARK: - Property
    
    var accessToken: String? { get set }
    var keychain: Keychain? { get }
    
    // MARK: - GitHub API
    func openLoginPageInBrowser() async throws
    func fetchAccessTokenWithCallbackURL(_ url: URL) async throws
    func logout() async throws
}

// MARK: - CRUD

extension TokenStoreProtocol {
    
    // MARK: Create / Update
    
    func addValue(_ accessToken: String) {
        self.accessToken = accessToken
        keychain?[Keychain.Key.accessToken] = accessToken
    }

    // MARK: Read

    func fetchValue() {
        accessToken = keychain?[Keychain.Key.accessToken]
    }

    // MARK: Delete
    
    func deleteValue() {
        accessToken = nil
        keychain?[Keychain.Key.accessToken] = nil
    }
}
