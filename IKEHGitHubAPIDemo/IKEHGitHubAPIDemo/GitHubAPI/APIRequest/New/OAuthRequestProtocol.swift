//
//  OAuthRequestProtocol.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//

import Foundation
import HTTPTypes

protocol OAuthRequestProtocol {
    
}

extension NewGitHubAPIRequestProtocol where Self: OAuthRequestProtocol {
    var baseURL: URL? {
        return URL(string: "https://github.com")
    }
    
    // e.g. "/search/repositories"
    var path: String {
        "/login/oauth/access_token"
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.contentType] = "application/json"
        headerFields[.accept] = "application/json"
        return headerFields
    }
}
