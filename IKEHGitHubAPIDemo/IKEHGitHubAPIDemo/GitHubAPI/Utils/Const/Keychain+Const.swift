//
//  Keychain+Const.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/03/18.
//

import KeychainAccess

extension Keychain {
    enum Constant {
        enum Service {
            static let oauth = "com.ikehgithubapi.oauth"
        }
        
        enum Key {
            static let accessToken = "ikehgithubapi-access-token"
        }
    }
}
