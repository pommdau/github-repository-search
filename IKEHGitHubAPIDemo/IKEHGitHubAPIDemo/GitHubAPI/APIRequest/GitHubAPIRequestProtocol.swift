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
    associatedtype Item: Sendable & Decodable & Equatable // 検索対象のDTO
    var method: HTTPRequest.Method { get }
    var path: String { get } // e.g. "/search/repositories"
    var queryItems: [URLQueryItem] { get }
    var body: Data? { get }
}

// MARK: - 共通のパラメータ/処理

extension GitHubAPIRequestProtocol {
    
    // MARK: - Define Type
    
    typealias SearchResponseType = SearchResponse<Item>
    
    // MARK: - Computed Property
    
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
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.accept] = "application/vnd.github.v3+json"
        if let apiVersionKey = HTTPField.Name.init("X-GitHub-Api-Version") {
            headerFields[apiVersionKey] = "2022-11-28"
        }
        return headerFields
    }
    
    // MARK: - Methods
    
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
