//
//  RequestTokenResponse.swift
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

//struct RequestTokenResponse: Decodable, Sendable {
//    
//    enum CodingKeys: String, CodingKey {
//        case accessToken = "access_token"
//        case accessTokenExpiresIn = "expires_in"
//        case refreshToken = "refresh_token"
//        case refreshTokenExpiresIn = "refresh_token_expires_in"
//        case tokenType = "token_type"
//        case scope
//    }
//    
//    let accessToken: String
//    let accessTokenExpiresIn: Int
//    let refreshToken: String
//    let refreshTokenExpiresIn: Int
//    let tokenType: String // e.g. "bearer"
//    let scope: String
//}
