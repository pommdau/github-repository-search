//
//  NewSearchRequest.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation
import HTTPTypes

// MARK: - 検索タイプ

extension GitHubAPIRequest {
    enum SearchType {
        case repo
        case user
        
        var apiPath: String {
            switch self {
            case .repo:
                return "/repositories"
            case .user:
                return "/users"
            }
        }
    }
}

extension GitHubAPIRequest {
    struct NewSearchRequest<Item: Decodable & Sendable> {
        var searchType: GitHubAPIRequest.SearchType
        var accessToken: String?
        var query: String
        var page: Int?
        var perPage: Int? = 10
    }
}

extension GitHubAPIRequest.NewSearchRequest : GitHubAPIRequestProtocol {

    typealias Response = SearchResponse<Item>
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        URL(string: "https://api.github.com/search")
    }
    
    var path: String {
        searchType.apiPath
    }
    
    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "q", value: query))
        if let page {
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        if let perPage {
            queryItems.append(URLQueryItem(name: "per_page", value: "\(perPage)"))
        }
        
        return queryItems
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.accept] = HTTPField.ConstantValue.applicationVndGitHubJSON
        if let accessToken {
            headerFields[.authorization] = "Bearer \(accessToken)"
        }
        headerFields[.xGithubAPIVersion] = HTTPField.ConstantValue.xGitHubAPIVersion
        return headerFields
    }
    
    var body: Data? {
        nil
    }
}
