//
//  FetchLoginUserPinnedRepos.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/26.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct FetchLoginUserPinnedRepos {
        var userName: String
        var accessToken: String
    }
}

extension GitHubAPIRequest.FetchLoginUserPinnedRepos: GitHubAPIRequestProtocol {

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
        let query = """
        {
          user(login: "GabrielBB") {
            pinnedItems(first: 6, types: REPOSITORY) {
              nodes {
                ... on Repository {
                  name
                  url
                  description
                  stargazerCount
                  primaryLanguage {
                    name
                  }
                }
              }
            }
          }
        }
        """
    }
}
