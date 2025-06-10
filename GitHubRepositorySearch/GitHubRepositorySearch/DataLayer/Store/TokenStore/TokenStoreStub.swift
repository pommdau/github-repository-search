//
//  TokenStoreStub.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import Foundation
import KeychainAccess
import IKEHGitHubAPIClient

final actor TokenStoreStub: TokenStoreProtocol {
    
    // MARK: - Property
    
    var accessToken: String?
    let keychain: Keychain? = nil // Stubではデータの永続化を行わないのでnil
    let gitHubAPIClient: GitHubAPIClientProtocol? = nil // Stubではデータの通信を行わないのでnil
    
    // MARK: - LifeCycle
    
    init(accessToken: String? = nil) {
        self.accessToken = accessToken
    }
}
