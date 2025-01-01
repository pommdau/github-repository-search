//
//  GitHubAPIRequest+GetRepoDetails.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//
/*  Discussion:
 > https://docs.github.com/ja/rest/overview/resources-in-the-rest-api#rate-limiting
 > For unauthenticated requests, the rate limit allows for up to 60 requests per hour. Unauthenticated requests are associated with the originating IP address, and not the person making requests.
 レート制限があるので、リポジトリごとに情報を取得していると簡単に上限に達してしまう。
 認証すれば話は別だが、現状では別の方法があるか考えたい。
 */

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct GetRepoDetails {
        let userName: String
        let repoName: String
    }
}

// MARK: - GitHubAPIRequestProtocol

extension GitHubAPIRequest.GetRepoDetails: GitHubAPIRequestProtocol {
    
    typealias Response = RepoDetails
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var path: String {
        "/repos/\(userName)/\(repoName)"
    }

    var queryItems: [URLQueryItem] {
        []
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
