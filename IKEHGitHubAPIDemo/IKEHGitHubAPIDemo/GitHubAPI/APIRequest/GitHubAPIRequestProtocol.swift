//
//  GitHubAPIRequest.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/07.
//

import Foundation
import HTTPTypes
import HTTPTypesFoundation

// MARK: - GitHubAPIRequestProtocol

protocol GitHubAPIRequestProtocol {
    associatedtype SearchResponseItem: Sendable & Decodable & Equatable // 検索対象のDTO
    var method: HTTPRequest.Method { get }
    var path: String { get } // e.g. "/search/repositories"
    var queryItems: [URLQueryItem] { get }
    var header: HTTPFields { get }
    var body: Data? { get }
}

// MARK: - 共通のパラメータ/処理

extension GitHubAPIRequestProtocol {
    
    typealias SearchResponse = SearchResponseDTO<SearchResponseItem>
    
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
