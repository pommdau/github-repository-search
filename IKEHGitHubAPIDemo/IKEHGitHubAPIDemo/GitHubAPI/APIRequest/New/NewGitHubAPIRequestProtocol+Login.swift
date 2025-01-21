//
//  NewGitHubAPIRequestProtocol+UpdateAccessToken.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//

import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension GitHubAPIRequest {
    struct UpdateAccessToken {
        let clientID: String
        let clientSecret: String
        let refreshToken: String
    }
}

// MARK: - GitHubAPIRequestProtocol

extension GitHubAPIRequest.UpdateAccessToken: GitHubAPIOAuthRequestProtocol {
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
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]
        return try? JSONSerialization.data(withJSONObject: body, options: [])
    }
}

extension GitHubAPIRequest {
    struct FetchFirstToken {
        let clientID: String
        let clientSecret: String
        let sessionCode: String
    }
}

// MARK: - GitHubAPIRequestProtocol

extension GitHubAPIRequest.FetchFirstToken: GitHubAPIOAuthRequestProtocol {
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
