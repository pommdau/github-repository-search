//
//  OAuthRequestProtocol.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//

import Foundation
import HTTPTypes

protocol OAuthRequestProtocol { }

extension GitHubAPIRequestProtocol where Self: OAuthRequestProtocol {
    
    typealias Response = RequestTokenResponse
    typealias ErrorResponse = AuthError
    
    var method: HTTPTypes.HTTPRequest.Method {
        .post
    }
    
    var baseURL: URL? {
        return URL(string: "https://github.com")
    }
    
    // e.g. "/search/repositories"
    var path: String {
        "/login/oauth/access_token"
    }
        
    var queryItems: [URLQueryItem] {
        return []
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.contentType] = HTTPField.ConstantValue.applicationJSON
        headerFields[.accept] = HTTPField.ConstantValue.applicationJSON
        return headerFields
    }
}
