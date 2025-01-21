//
//  NewGitHubAPIRequestProtocol.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//

import Foundation
import HTTPTypes
import HTTPTypesFoundation

// MARK: - GitHubAPIRequestProtocol

protocol GitHubAPIOAuthRequestProtocol {
    associatedtype Response: Codable
    var method: HTTPRequest.Method { get }
    var queryItems: [URLQueryItem] { get }
    var body: Data? { get }
}

// MARK: - 共通のパラメータ/処理

extension GitHubAPIOAuthRequestProtocol {
            
    // MARK: - Computed Property
        
    private var baseURL: URL? {
        return URL(string: "https://github.com")
    }
    
    // e.g. "/search/repositories"
    private var path: String {
        "/login/oauth/access_token"
    }
    
    /// クエリパラメータを含めたURL
    var url: URL? {
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
        headerFields[.contentType] = "application/json"
        headerFields[.accept] = "application/json"
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
