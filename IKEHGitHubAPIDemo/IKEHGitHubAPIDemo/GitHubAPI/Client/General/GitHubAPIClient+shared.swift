//
//  GitHubAPIClient+shared.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/19.
//

import Foundation

extension GitHubAPIClient {
    static let shared: GitHubAPIClient = .init(
        clientID: PrivateConst.clientID,
        clientSecret: PrivateConst.clientSecret
    )
}
