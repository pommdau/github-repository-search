//
//  FetchFirstToken.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//
//  refs: https://docs.github.com/ja/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps

import Foundation
import HTTPTypes

extension GitHubRESTAPIRequest {
    public struct FetchInitialToken {
        var clientID: String
        var clientSecret: String
        var sessionCode: String
        
        public init(clientID: String, clientSecret: String, sessionCode: String) {
            self.clientID = clientID
            self.clientSecret = clientSecret
            self.sessionCode = sessionCode
        }
    }        
}

extension GitHubRESTAPIRequest.FetchInitialToken: GitHubRESTAPIRequestProtocol {
    
    public typealias Response = FetchInitialTokenResponse
    
    public var responseFailType: ResponseFailType {
        .responseBody
    }
    
    public var method: HTTPTypes.HTTPRequest.Method {
        .post
    }
    
    public var baseURL: URL? {
        GitHubRESTAPIEndpoints.oauthBaseURL
    }
    
    public var path: String {
        "/login/oauth/access_token"
    }
        
    public var queryItems: [URLQueryItem] {
        []
    }
    
    public var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.contentType] = HTTPField.ConstValue.applicationJSON
        headerFields[.accept] = HTTPField.ConstValue.applicationJSON
        
        return headerFields
    }
    
    public var body: Data? {
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
