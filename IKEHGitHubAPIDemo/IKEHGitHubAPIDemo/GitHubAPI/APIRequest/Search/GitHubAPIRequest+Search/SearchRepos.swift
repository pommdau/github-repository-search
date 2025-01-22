//
//  SearchRepo.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest.Search {
    struct Repos {
        var accessToken: String?
        var query: String
        var page: Int?
        var perPage: Int? = 10
    }
}

extension GitHubAPIRequest.Search.Repos: GitHubAPIRequestProtocol, SearchRequestProtocol {
    typealias Item = Repo
    var path: String {
        "/repositories"
    }
}
