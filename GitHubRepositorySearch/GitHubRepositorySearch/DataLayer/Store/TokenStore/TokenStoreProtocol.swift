//
//  TokenStoreProtocol.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import Foundation
import KeychainAccess
import IKEHGitHubAPIClient

protocol TokenStoreProtocol: Actor {

    // MARK: - Property
    
    var accessToken: String? { get set }
    var keychain: Keychain? { get }
    var gitHubAPIClient: GitHubAPIClientProtocol? { get }
}

// MARK: - CRUD

extension TokenStoreProtocol {
    
    // MARK: Create / Update
    
    func addValue(_ accessToken: String) {
        self.accessToken = accessToken
        keychain?[Keychain.Key.accessToken] = accessToken
    }

    // MARK: Read

    func loadSavedValues() {
        accessToken = keychain?[Keychain.Key.accessToken]
    }

    // MARK: Delete
    
    func deleteValue() {
        accessToken = nil
        keychain?[Keychain.Key.accessToken] = nil
    }
}

// MARK: - GitHub API

extension TokenStoreProtocol {
        
    func openLoginPageInBrowser() async throws {
       try await gitHubAPIClient?.openLoginPageInBrowser()
    }
    
    func fetchAccessTokenWithCallbackURL(_ url: URL) async throws {
        if let accessToken = try await gitHubAPIClient?.recieveLoginCallBackURLAndFetchAccessToken(url) {
            addValue(accessToken)
        }
    }
    
    func logout() async throws {        
        defer {
            // サーバ上の情報を削除できない場合もローカル上の情報を削除する
            deleteValue()
        }
        guard let accessToken else {
            return
        }
        try await gitHubAPIClient?.logout(accessToken: accessToken) // サーバ上の情報の削除
    }
}
