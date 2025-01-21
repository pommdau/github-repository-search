//
//  FetchFirstToken.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest.OAuth {
    struct FetchFirstToken {
        let clientID: String
        let clientSecret: String
        let sessionCode: String
    }
}

extension GitHubAPIRequest.OAuth.FetchFirstToken: NewGitHubAPIRequestProtocol, OAuthRequestProtocol {
    typealias Response = FetchTokenResponse
    
    var method: HTTPTypes.HTTPRequest.Method {
        .post
    }

    var queryItems: [URLQueryItem] {
        return []
    }

    var body: Data? {
        let body: [String: String] = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "code": sessionCode
        ]
        return try? JSONSerialization.data(withJSONObject: body, options: [])
    }
}
