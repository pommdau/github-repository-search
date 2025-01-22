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
        headerFields[.accept] = "application/vnd.github+json"
        headerFields[.authorization] = "Bearer \(accessToken)"
        if let apiVersionKey = HTTPField.Name.init("X-GitHub-Api-Version") {
            headerFields[apiVersionKey] = "2022-11-28"
        }
        return headerFields
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
    
    var body: Data? {
        return nil
    }
}
