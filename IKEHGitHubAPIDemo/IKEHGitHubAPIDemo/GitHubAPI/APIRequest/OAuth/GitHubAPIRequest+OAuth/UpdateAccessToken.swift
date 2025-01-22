//
//  GitHubAPIRequest+OAuth+UpdateAccessToken.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest.OAuth {
    struct UpdateAccessToken {
        var clientID: String
        var clientSecret: String
        var refreshToken: String
    }
}

extension GitHubAPIRequest.OAuth.UpdateAccessToken : GitHubAPIRequestProtocol, OAuthRequestProtocol {
    var body: Data? {
        let body: [String: String] = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]
        return try? JSONSerialization.data(withJSONObject: body, options: [])
    }
}
