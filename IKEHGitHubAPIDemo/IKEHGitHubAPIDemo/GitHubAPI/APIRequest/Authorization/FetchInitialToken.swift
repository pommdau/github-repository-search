//
//  FetchFirstToken.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//
//  refs: https://docs.github.com/ja/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct FetchInitialToken {
        var clientID: String
        var clientSecret: String
        var sessionCode: String
    }
}

extension GitHubAPIRequest.FetchInitialToken: GitHubAPIRequestProtocol {
    
    typealias Response = FetchInitialTokenResponse
    
    var responseFailType: ResponseFailType {
        .responseBody
    }
    
    var method: HTTPTypes.HTTPRequest.Method {
        .post
    }
    
    var baseURL: URL? {
        URL(string: "https://github.com")
    }
    
    var path: String {
        "/login/oauth/access_token"
    }
        
    var queryItems: [URLQueryItem] {
        []
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.contentType] = HTTPField.ConstantValue.applicationJSON
        headerFields[.accept] = HTTPField.ConstantValue.applicationJSON
        
        return headerFields
    }
    
    var body: Data? {
        let body: [String: String] = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "code": sessionCode
        ]
        
        do {
            return try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to serialize JSON: \(error)")
            return nil
        }
    }
}
