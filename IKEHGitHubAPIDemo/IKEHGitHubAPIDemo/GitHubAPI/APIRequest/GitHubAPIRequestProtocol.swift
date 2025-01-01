//
//  GitHubAPIRequestProtocol.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/08.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import HTTPTypes
import HTTPTypesFoundation

protocol GitHubAPIRequestProtocol {
    associatedtype Response: Decodable
    var method: HTTPRequest.Method { get }
    var path: String { get } // e.g. "/search/repositories"
    var queryItems: [URLQueryItem] { get }
    var header: HTTPFields { get }
    var body: Data? { get }
}

// MARK: - 共通処理

extension GitHubAPIRequestProtocol {
    
    // e.g. "https"
    private var scheme: String {
        "https"
    }
    
    // e.g. "www.example.com"
    private var authority: String {
        "api.github.com"
    }
    
    /// クエリパラメータを含まないURL
    private var baseURL: URL? {
        return URL(string: "\(scheme)://\(authority)")
    }
    
    /// クエリパラメータを含めたURL
    private var url: URL? {
        guard
            let baseURL,
            var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        else {
            return nil
        }
        components.queryItems = queryItems
        
        return components.url
    }
    
    func buildHTTPRequest() -> HTTPRequest? {
        guard let url else {
            return nil
        }
        
        return HTTPRequest(
            method: method,
            url: url,
            headerFields: header
        )
    }
}
