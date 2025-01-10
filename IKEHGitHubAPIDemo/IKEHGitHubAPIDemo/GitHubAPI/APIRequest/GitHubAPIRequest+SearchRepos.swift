//
//  GitHubAPIRequest+SearchRepos.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/07.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct SearchRepos {
        let keyword: String
    }
}

// MARK: - GitHubAPIRequestProtocol

extension GitHubAPIRequest.SearchRepos: GitHubAPIRequestProtocol {
    
//    typealias Response = SearchResponseDTO<RepoDTO>
    typealias SearchResponseItem = RepoDTO
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var path: String {
        "/search/repositories"
    }

    var queryItems: [URLQueryItem] {
        return [
            URLQueryItem(name: "q", value: keyword)            
        ]
    }

    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.accept] = "application/vnd.github.v3+json"
        return headerFields
    }

    var body: Data? {
        nil
    }
}
