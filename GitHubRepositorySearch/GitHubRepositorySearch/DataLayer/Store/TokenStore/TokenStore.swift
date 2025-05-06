//
//  TokenStore.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import Foundation
import KeychainAccess
import IKEHGitHubAPIClient

final actor TokenStore: TokenStoreProtocol {

    // MARK: - Property
        
    static let shared: TokenStore = .init()
    
    let keychain: Keychain?
    let gitHubAPIClient: GitHubAPIClientProtocol

    var accessToken: String? {
        didSet {
            keychain?[Keychain.Key.accessToken] = accessToken
        }
    }
    
    // MARK: - LifeCycle
    
    init(
        keyChain: Keychain? = Keychain(service: Keychain.Service.oauth),
        gitHubAPIClient: GitHubAPIClientProtocol = GitHubAPIClient.shared,
    ) {
        // DI
        self.keychain = keyChain
        self.gitHubAPIClient = gitHubAPIClient
        
        // 保存値の復元
        self.accessToken = keychain?[Keychain.Key.accessToken]
    }
    
    // MARK: - GitHub API
    
    func openLoginPageInBrowser() async throws {
       try await gitHubAPIClient.openLoginPageInBrowser()
    }
    
    func fetchAccessTokenWithCallbackURL(_ url: URL) async throws {
        self.accessToken = try await gitHubAPIClient.recieveLoginCallBackURLAndFetchAccessToken(url)
    }
    
    func logout() async throws {
        guard let accessToken else {
            return
        }
        defer {
            // サーバ上の情報を削除できない場合もローカル上の情報を削除する
            self.accessToken = nil
        }
        try await gitHubAPIClient.logout(accessToken: accessToken) // サーバ上の情報の削除
    }
}
