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
    
    // MARK: Types
    
    associatedtype Response: Decodable
    
    // MARK: General
    
    var method: HTTPRequest.Method { get }
    
    // MARK: URL
    
    var baseURL: URL? { get }
    var path: String { get } // e.g. "/search/repositories"
    var queryItems: [URLQueryItem] { get }
    
    // MARK: Data
    
    var header: HTTPTypes.HTTPFields { get }
    var body: Data? { get }
}

// MARK: - 共通処理

extension GitHubAPIRequestProtocol {
        
    /// クエリパラメータを含めたURL
    var url: URL? {
        guard
            let baseURL,
            var components = URLComponents(
                url: baseURL.appendingPathComponent(path),
                resolvingAgainstBaseURL: true
            )
        else {
            return nil
        }
        // 0個の場合末尾に?がついてしまうのを防止
        if queryItems.count > 0 {
            components.queryItems = queryItems            
        }
        
        return components.url
    }
    
    
    /// プロパティの値からHTTPRequestを作成
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
