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
        let page: Int?
        let perPage: Int = 10 // 検索結果の上限数 Range: 1~100. Default: 30
    }
}

// MARK: - GitHubAPIRequestProtocol

extension GitHubAPIRequest.SearchRepos: GitHubAPIRequestProtocol {
    
    typealias Item = Repo
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var path: String {
        "/search/repositories"
    }

    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "q", value: keyword))
        if let page {
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        queryItems.append(URLQueryItem(name: "per_page", value: "\(perPage)"))
        
        return queryItems
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
