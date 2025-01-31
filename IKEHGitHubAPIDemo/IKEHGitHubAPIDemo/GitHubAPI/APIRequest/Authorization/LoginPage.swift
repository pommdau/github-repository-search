//
//  LoginPage.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/30.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct LoginPage {
        var clientID: String
        var lastLoginStateID: String
    }
}

extension GitHubAPIRequest.LoginPage: GitHubAPIRequestProtocol {
    
    // unused
    typealias Response = String
    
    // unused
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        URL(string: "https://github.com/login")
    }
    
    var path: String {
        "/oauth/authorize/"
    }
    
    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: "ikehgithubapi://callback"), // Callback URL
            URLQueryItem(name: "state", value: lastLoginStateID),
            //            URLQueryItem(name: "scope", value: "public_repo,read:user")
        ]
    }
    
    // unused
    var header: HTTPTypes.HTTPFields {
        .init()
    }
    
    // unused
    var body: Data? {
        nil
    }
}
