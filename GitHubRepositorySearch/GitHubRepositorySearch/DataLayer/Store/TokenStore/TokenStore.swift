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
    var gitHubAPIClient: GitHubAPIClient?
        
    // MARK: - LifeCycle
    
    init(
        keyChain: Keychain? = Keychain(service: Keychain.Service.oauth),
        gitHubAPIClient: GitHubAPIClient = GitHubAPIClient.shared
    ) {
        // DI
        self.keychain = keyChain
        self.gitHubAPIClient = gitHubAPIClient
        
        Task {
            await fetchValue()
        }
    }
}
