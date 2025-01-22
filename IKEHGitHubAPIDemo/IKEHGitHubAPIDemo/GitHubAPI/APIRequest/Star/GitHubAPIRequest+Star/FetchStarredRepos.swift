//
//  FetchStarredRepos.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/22.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest.Star {
    struct FetchStarredRepos {
        var accessToken: String
    }
}

extension GitHubAPIRequest.Star.FetchStarredRepos: GitHubAPIRequestProtocol, StarRequestProtocol {
    
    typealias Response = [Repo]
    typealias ErrorResponse = GitHubAPIError
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        return URL(string: "https://api.github.com")
    }
    
    var path: String {
        "/user/starred"
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.accept] = HTTPField.ConstantValue.applicationVndGitHubJSON
        headerFields[.authorization] = "Bearer \(accessToken)"
        headerFields[.xGithubAPIVersion] = HTTPField.ConstantValue.xGitHubAPIVersion
        return headerFields
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
    
    var body: Data? {
        return nil
    }
}
