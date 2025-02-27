//
//  FetchLoginUserPinnedRepos.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/26.
//
//  refs: https://docs.github.com/ja/graphql/reference/interfaces

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct FetchLoginUserPinnedRepos {
        var userName: String
        var accessToken: String?
    }
}

extension GitHubAPIRequest.FetchLoginUserPinnedRepos: GitHubAPIRequestProtocol {

    typealias Response = ListResponse<Repo>
    
    var method: HTTPTypes.HTTPRequest.Method {
        .post
    }
    
    var baseURL: URL? {
        URL(string: "https://api.github.com/graphql")
    }
    
    var path: String {
        ""
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
//        let query = """
//        {
//          user(login: "\(userName)") {
//            pinnedItems(first: 6, types: REPOSITORY) {
//              nodes {
//                ... on Repository {
//                  name
//                  url
//                  description
//                  stargazerCount
//                  primaryLanguage {
//                    name
//                  }
//                }
//              }
//            }
//          }
//        }
//        """
        let query =
        #"""
        {
            "query": "query { user(login: \"GabrielBB\") { pinnedItems(first: 6, types: REPOSITORY) { nodes { ... on Repository { name } } } } }"
          }
        """#
        return query.data(using: .utf8)
    }
}
