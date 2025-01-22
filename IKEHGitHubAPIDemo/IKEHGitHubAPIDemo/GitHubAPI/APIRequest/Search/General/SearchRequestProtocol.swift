//
//  SearchRequestProtocol.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//

import Foundation
import HTTPTypes

protocol SearchRequestProtocol {
    associatedtype Item: Decodable & Sendable
    var accessToken: String? { get }
    var query: String { get } // 検索語句
    var page: Int? { get } // ページング番号
    var perPage: Int? { get } // 1リクエストあたりの上限数(範囲: 1~100 デフォルト: 30)
}

extension GitHubAPIRequestProtocol where Self: SearchRequestProtocol {
    
    typealias Response = SearchResponse<Item>
    typealias ErrorResponse = GitHubAPIError
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        return URL(string: "https://api.github.com/search")
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
    
    var body: Data? {
        return nil
    }
}
