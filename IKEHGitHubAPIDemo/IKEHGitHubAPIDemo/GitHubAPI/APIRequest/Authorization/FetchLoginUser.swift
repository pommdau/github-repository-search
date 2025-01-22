//
//  FetchLoginUser.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct FetchLoginUser {
        var accessToken: String
    }
}

extension GitHubAPIRequest.FetchLoginUser: GitHubAPIRequestProtocol {

    typealias Response = LoginUser
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        URL(string: "https://api.github.com")
    }
    
    var path: String {
        "/user"
    }
    
    var queryItems: [URLQueryItem] {
        []
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.authorization] = "Bearer \(accessToken)"
        headerFields[.accept] = HTTPField.ConstantValue.applicationVndGitHubJSON
        headerFields[.xGithubAPIVersion] = HTTPField.ConstantValue.xGitHubAPIVersion
        return headerFields
    }
    
    var body: Data? {
        nil
    }
}
