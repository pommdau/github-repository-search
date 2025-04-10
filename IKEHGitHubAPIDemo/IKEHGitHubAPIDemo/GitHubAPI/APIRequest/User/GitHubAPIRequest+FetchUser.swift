//
//  GitHubAPIRequest+FetchRepos.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/03/21.
//

import Foundation
import HTTPTypes

// MARK: - FetchLoginUser

//  refs: https://docs.github.com/en/rest/users/users?apiVersion=2022-11-28

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
        headerFields[.accept] = HTTPField.ConstValue.applicationVndGitHubJSON
        headerFields[.xGithubAPIVersion] = HTTPField.ConstValue.xGitHubAPIVersion
        return headerFields
    }
    
    var body: Data? {
        nil
    }
}

// MARK: - FetchUser

//  refs: https://docs.github.com/ja/rest/users/users?apiVersion=2022-11-28#get-a-user

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
