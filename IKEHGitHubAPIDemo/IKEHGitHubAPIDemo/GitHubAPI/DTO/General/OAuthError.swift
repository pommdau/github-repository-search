//
//  AuthError.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation

struct OAuthError: GitHubAPIErrorProtocol {
    enum CodingKeys: String, CodingKey {
        case error
        case errorDescriptionPrivate = "error_description"
        case errorURI = "error_uri"
    }
    let error: String
    let errorDescriptionPrivate: String
    let errorURI: String?
    
    var statusCode: Int?
    
    // MARK: - LocalizedError
    
    var errorDescription: String? {
        return errorDescriptionPrivate
    }
}

/*
{
  "error": "bad_refresh_token",
  "error_description": "The refresh token passed is incorrect or expired.",
  "error_uri": "https://docs.github.com/apps/managing-oauth-apps/troubleshooting-oauth-app-access-token-request-errors/#bad-verification-code"
}
*/
