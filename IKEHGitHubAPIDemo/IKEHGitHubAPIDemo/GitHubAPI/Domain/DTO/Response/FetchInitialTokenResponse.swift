//
//  FetchInitialTokenResponse.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/22.
//

import Foundation

/*
 {"access_token":"xxx","token_type":"bearer","scope":"repo"}
 */
struct FetchInitialTokenResponse: Decodable, Sendable {    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
    }
    
    var accessToken: String
    var tokenType: String
    var scope: String // e.g. "bearer"
}
