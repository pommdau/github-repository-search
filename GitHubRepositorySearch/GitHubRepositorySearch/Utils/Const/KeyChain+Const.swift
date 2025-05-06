//
//  KeyChain+Const.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import Foundation
import KeychainAccess

extension Keychain {
    enum Service {
        static let oauth = "com.ikeh1024.IKEHGitHubAPIDemo.oauth"
    }
    
    enum Key {
        static let accessToken = "com.ikeh1024.IKEHGitHubAPIDemo.accessToken"
    }
}
