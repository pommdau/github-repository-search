//
//  FetchInitialTokenResponse.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/22.
//

import Foundation

struct FetchInitialTokenResponse: Codable, Sendable {    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
    }
    
    var accessToken: String
    var tokenType: String // e.g. "bearer"
    var scope: String // e.g. "repo"
}

// MARK: - Mock

extension FetchInitialTokenResponse {
    enum Mock {
        static var success: FetchInitialTokenResponse {
            .init(
                accessToken: "gho_dummyAccessToken1234567890",
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
  "access_token": "gho_dummyAccessToken1234567890",
  "token_type": "bearer",
  "scope": "repo"
}
"""
    }
}
