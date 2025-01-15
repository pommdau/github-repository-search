//
//  GitHubAPIRequest+SearchUsers.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/15.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct SearchUsers {
        let searchText: String
        let page: Int?
        let perPage: Int = 10 // 検索結果の上限数 Range: 1~100. Default: 30
    }
}

// MARK: - GitHubAPIRequestProtocol

extension GitHubAPIRequest.SearchUsers: GitHubAPIRequestProtocol {
    
    typealias Item = User
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var path: String {
        "/search/users"
    }

    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "q", value: searchText))
        if let page {
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        queryItems.append(URLQueryItem(name: "per_page", value: "\(perPage)"))
        
        return queryItems
    }

    var body: Data? {
        nil
    }
}
