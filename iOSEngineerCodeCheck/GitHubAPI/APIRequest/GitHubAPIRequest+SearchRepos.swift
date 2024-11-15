//
//  GitHubAPIRequest+SearchRepos.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/08.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

extension GitHubAPIRequest {

    public struct SearchRepos: GitHubAPIRequestProtocol {

        public typealias Response = SearchResponse<Repo>

        public let keyword: String

        public var method: HTTPMethod {
            .get
        }

        public var path: String {
            "/search/repositories"
        }

        public var queryItems: [URLQueryItem] {
            [URLQueryItem(name: "q", value: keyword)]
        }

        public var header: [String: String] {
            ["Accept": "application/vnd.github.v3+json"]
        }

        public var body: Data? {
            nil
        }
    }

}
