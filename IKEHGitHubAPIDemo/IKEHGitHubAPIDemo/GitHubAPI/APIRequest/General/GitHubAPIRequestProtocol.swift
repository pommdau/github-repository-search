//
//  NewGitHubAPIRequestProtocol.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//

import Foundation
import HTTPTypes

// MARK: - GitHubAPIRequestProtocol

protocol GitHubAPIRequestProtocol {
    associatedtype Response: Decodable
    associatedtype ErrorResponse: Decodable & Error
    var method: HTTPRequest.Method { get }
    
    var baseURL: URL? { get }
    var path: String { get } // e.g. "/search/repositories"
    var queryItems: [URLQueryItem] { get }
    
    var header: HTTPTypes.HTTPFields { get }
    var body: Data? { get }
}

// MARK: - 共通処理

extension GitHubAPIRequestProtocol {
        
    /// クエリパラメータを含めたURL
    var url: URL? {
        guard
            let baseURL,
            var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        else {
            return nil
        }
        if queryItems.count > 0 {
            components.queryItems = queryItems            
        }
        
        return components.url
    }
    
    // MARK: - Methods
    
    func buildHTTPRequest() -> HTTPRequest? {
        guard let url else {
            return nil
        }
        
        print(method)
        print(url)
        print(header)
        
        return HTTPRequest(
            method: method,
            url: url,
            headerFields: header
        )
    }
}
