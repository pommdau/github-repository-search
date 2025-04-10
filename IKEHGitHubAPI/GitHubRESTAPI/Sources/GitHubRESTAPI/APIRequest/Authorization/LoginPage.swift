//
//  LoginPage.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/30.
//

import Foundation
import HTTPTypes

extension GitHubRESTAPIRequest {
    public struct LoginPage {
        var clientID: String
        var callbackURL: URL
        var lastLoginStateID: String?
        
        var loginURL: URL? {
            self.url
        }
        
        public init(clientID: String, callbackURL: URL, lastLoginStateID: String? = nil) {
            self.clientID = clientID
            self.callbackURL = callbackURL
            self.lastLoginStateID = lastLoginStateID
        }
    }
}

extension GitHubRESTAPIRequest.LoginPage: GitHubRESTAPIRequestProtocol {
    
    public typealias Response = NoBodyResponse
    
    // unused
    public var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    public var baseURL: URL? {
        GitHubRESTAPIEndpoints.oauthBaseURL
    }
    
    public var path: String {
        "/login/oauth/authorize"
    }
    
    public var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "client_id", value: clientID))
        queryItems.append(URLQueryItem(name: "redirect_uri", value: callbackURL.absoluteString)) // Callback URL
        if let lastLoginStateID {
            queryItems.append(URLQueryItem(name: "state", value: lastLoginStateID))
        }
        //            URLQueryItem(name: "scope", value: "public_repo,read:user")
        queryItems.append(URLQueryItem(name: "scope", value: "repo"))
        
        return queryItems
    }
    
    // unused
    public var header: HTTPTypes.HTTPFields {
        .init()
    }
    
    // unused
    public var body: Data? {
        nil
    }
}
