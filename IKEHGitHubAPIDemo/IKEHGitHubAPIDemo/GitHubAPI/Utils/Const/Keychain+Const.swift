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
            static let oauth = "com.ikeh1024.IKEHGitHubAPIDemo.oauth"
        }
        
        enum Key {
            static let accessToken = "com.ikeh1024.IKEHGitHubAPIDemo.accessToken"
        }
    }
}
