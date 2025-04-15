//
//  AuthError.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation

public struct OAuthError: Sendable, Codable, Error, LocalizedError {
    enum CodingKeys: String, CodingKey {
        case error
        case errorDescriptionPrivate = "error_description"
        case errorURI = "error_uri"
    }
    let error: String
    let errorDescriptionPrivate: String
    let errorURI: String?
    
    // レスポンスヘッダから取得される値
    public var statusCode: Int?
    
    // MARK: - LocalizedError
    
    public var errorDescription: String? {
        return errorDescriptionPrivate
    }
}

// MARK: - Mock

extension OAuthError {
    enum Mock {
        static var incorrectClientCredentials: OAuthError {
            .init(
                error: "incorrect_client_credentials",
                errorDescriptionPrivate: "The client_id and/or client_secret passed are incorrect.",
                errorURI: "https://docs.github.com/apps/managing-oauth-apps/troubleshooting-oauth-app-access-token-request-errors/#incorrect-client-credentials",
                statusCode: 200 // エラーの場合もステータスコードは200
            )
        }
    }
}

// MARK: - JSONString

extension OAuthError.Mock {
    enum JSONString {
        static let incorrectClientCredentials = """
{
  "error":"incorrect_client_credentials",
  "error_description":"The client_id and/or client_secret passed are incorrect.",
  "error_uri":"https://docs.github.com/apps/managing-oauth-apps/troubleshooting-oauth-app-access-token-request-errors/#incorrect-client-credentials"
}
"""
    }
}
