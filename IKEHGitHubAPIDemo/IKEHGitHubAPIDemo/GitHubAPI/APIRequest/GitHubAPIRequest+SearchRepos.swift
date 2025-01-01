//
//  GitHubAPIRequest+SearchRepos.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/08.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
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
    
    typealias Response = SearchResponse<Repo>
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var path: String {
        "/search/repositories"
    }

    var queryItems: [URLQueryItem] {
        [URLQueryItem(name: "q", value: keyword)]
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
