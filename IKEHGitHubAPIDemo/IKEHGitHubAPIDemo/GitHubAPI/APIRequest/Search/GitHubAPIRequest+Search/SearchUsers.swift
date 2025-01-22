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
        var accessToken: String?
        var query: String
        var page: Int?
        var perPage: Int? = 10
    }
}

extension GitHubAPIRequest.Search.Users: GitHubAPIRequestProtocol, SearchRequestProtocol {
    typealias Item = User
    var path: String {
        "/users"
    }
}
