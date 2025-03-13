//
//  FetchUserRepos.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/03/08.
//
//  refs: https://docs.github.com/ja/rest/repos/repos?apiVersion=2022-11-28#list-repositories-for-a-user

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct FetchUserRepos {
        var accessToken: String?
        var userName: String
        var type: String?
        var sort: String?
        var direction: String?
        var perPage: Int? = 1
        var page: Int?
    }
}

extension GitHubAPIRequest.FetchUserRepos: GitHubAPIRequestProtocol {

    typealias Response = ListResponse<Repo>
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        URL(string: "https://api.github.com")
    }
    
    var path: String {
        "/users/\(userName)/repos"
    }
    
    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        if let type {
            queryItems.append(URLQueryItem(name: "type", value: type))
        }
        if let sort {
            queryItems.append(URLQueryItem(name: "sort", value: sort))
        }
        if let direction {
            queryItems.append(URLQueryItem(name: "direction", value: direction))
        }
        if let perPage {
            queryItems.append(URLQueryItem(name: "per_page", value: "\(perPage)"))
        }
        if let page {
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        
        return queryItems
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
