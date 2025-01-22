//
//  FetchFirstToken.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest.OAuth {
    struct FetchInitialToken {
        var clientID: String
        var clientSecret: String
        var sessionCode: String
    }
}

extension GitHubAPIRequest.OAuth.FetchInitialToken: NewGitHubAPIRequestProtocol, OAuthRequestProtocol {
    var body: Data? {
        let body: [String: String] = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "code": sessionCode
        ]
        return try? JSONSerialization.data(withJSONObject: body, options: [])
    }
}
