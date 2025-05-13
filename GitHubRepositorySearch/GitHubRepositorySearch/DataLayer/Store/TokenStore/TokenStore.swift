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
    var accessToken: String?
    
    private let gitHubAPIClient: GitHubAPIClient
    
    // MARK: - LifeCycle
    
    init(
        keyChain: Keychain? = Keychain(service: Keychain.Service.oauth),
        gitHubAPIClient: GitHubAPIClient = GitHubAPIClient.shared,
    ) {
        // DI
        self.keychain = keyChain
        self.gitHubAPIClient = gitHubAPIClient
        
        Task {
            await fetchValue()
        }
    }
}

// MARK: - GitHub API

extension TokenStore {
        
    func openLoginPageInBrowser() async throws {
       try await gitHubAPIClient.openLoginPageInBrowser()
    }
    
    func fetchAccessTokenWithCallbackURL(_ url: URL) async throws {
        let accessToken = try await gitHubAPIClient.recieveLoginCallBackURLAndFetchAccessToken(url)
        addValue(accessToken)
    }
    
    func logout() async throws {
        guard let accessToken else {
            return
        }
        defer {
            // サーバ上の情報を削除できない場合もローカル上の情報を削除する
            deleteValue()
        }
        try await gitHubAPIClient.logout(accessToken: accessToken) // サーバ上の情報の削除
    }
}
