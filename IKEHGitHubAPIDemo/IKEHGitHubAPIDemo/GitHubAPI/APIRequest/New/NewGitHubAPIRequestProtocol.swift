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

protocol NewGitHubAPIRequestProtocol {
    associatedtype Response: Codable
    var method: HTTPRequest.Method { get }
    
    var baseURL: URL? { get }
    var path: String { get } // e.g. "/search/repositories"
    
    var header: HTTPTypes.HTTPFields { get }
    var queryItems: [URLQueryItem] { get }
    var body: Data? { get }
}

// MARK: - 共通のパラメータ/処理

extension NewGitHubAPIRequestProtocol {                
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
