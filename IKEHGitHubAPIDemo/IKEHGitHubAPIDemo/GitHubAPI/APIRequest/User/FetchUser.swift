//
//  FetchUser.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/03/08.
//
//  refs: https://docs.github.com/ja/rest/users/users?apiVersion=2022-11-28#get-a-user

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct FetchUser {
        var accessToken: String?
        var userName: String
    }
}

extension GitHubAPIRequest.FetchUser: GitHubAPIRequestProtocol {

    typealias Response = User
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        URL(string: "https://api.github.com")
    }
    
    var path: String {
        "/users/\(userName)"
    }
    
    var queryItems: [URLQueryItem] {
        []
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        if let accessToken {
            headerFields[.authorization] = "Bearer \(accessToken)"
        }
        headerFields[.accept] = HTTPField.ConstValue.applicationVndGitHubJSON
        headerFields[.xGithubAPIVersion] = HTTPField.ConstValue.xGitHubAPIVersion
        return headerFields
    }
    
    var body: Data? {
        nil
    }
}
