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
    var query: String { get } // 検索語句
    var page: Int? { get } // ページング番号
    var perPage: Int? { get } // 1リクエストあたりの上限数(範囲: 1~100 デフォルト: 30)
}

extension NewGitHubAPIRequestProtocol where Self: SearchRequestProtocol {
    
    typealias Response = SearchResponse<Item>
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        return URL(string: "https://api.github.com/search")
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
//        headerFields[.contentType] = "application/json"
        headerFields[.accept] = "application/vnd.github+json"
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
