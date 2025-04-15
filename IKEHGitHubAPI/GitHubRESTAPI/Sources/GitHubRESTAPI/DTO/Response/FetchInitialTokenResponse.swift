//
//  File.swift
//  GitHubRESTAPI
//
//  Created by HIROKI IKEUCHI on 2025/04/13.
//

import Foundation


public struct FetchInitialTokenResponse: Codable, Sendable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
    }
    
    public var accessToken: String
    public var tokenType: String // e.g. "bearer"
    public var scope: String // e.g. "repo"
}

// MARK: - Mock

extension FetchInitialTokenResponse {
    enum Mock {
        static var success: FetchInitialTokenResponse {
            .init(
                accessToken: "dummy-access-token",
                tokenType: "bearer",
                scope: "repo"
            )
        }
    }
}

// MARK: - JSONString

extension FetchInitialTokenResponse.Mock {
    enum JSONString {
        static let success = """
{
  "access_token": "dummy-access-token",
  "token_type": "bearer",
  "scope": "repo"
}
"""
    }
}
