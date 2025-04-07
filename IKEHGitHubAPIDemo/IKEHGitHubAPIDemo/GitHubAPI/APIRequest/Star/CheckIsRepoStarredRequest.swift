//
//  CheckIsRepoStarredRequest.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/29.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct CheckIsRepoStarredRequest {
        var accessToken: String
        var ownerName: String
        var repoName: String
    }
}

extension GitHubAPIRequest.CheckIsRepoStarredRequest: GitHubAPIRequestProtocol {

    typealias Response = NoBodyResponse
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        URL(string: "https://api.github.com")
    }
    
    var path: String {
        "/user/starred/\(ownerName)/\(repoName)"
    }
    
    var queryItems: [URLQueryItem] {
        []
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.accept] = HTTPField.ConstValue.applicationVndGitHubJSON
        headerFields[.authorization] = "Bearer \(accessToken)"
        headerFields[.xGithubAPIVersion] = HTTPField.ConstValue.xGitHubAPIVersion
        return headerFields
    }
    
    var body: Data? {
        nil
    }
}
