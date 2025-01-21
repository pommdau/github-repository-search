//
//  SearchUsers.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest.Search {
    struct Users {
        let query: String
        let page: Int?
        let perPage: Int?
    }
}

extension GitHubAPIRequest.Search.Users: NewGitHubAPIRequestProtocol, SearchRequestProtocol {
    typealias Item = User
    var path: String {
        "/users"
    }
}
