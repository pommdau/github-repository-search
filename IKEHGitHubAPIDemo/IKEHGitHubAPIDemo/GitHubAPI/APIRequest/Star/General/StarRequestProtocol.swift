//
//  StarRequestProtocol.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/22.
//

import Foundation
import HTTPTypes

protocol StarRequestProtocol {
    var accessToken: String { get }
}

extension GitHubAPIRequestProtocol where Self: StarRequestProtocol {
    
    typealias Response = [Repo]
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        return URL(string: "https://api.github.com")
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
