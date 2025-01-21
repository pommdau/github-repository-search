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
    var path: String { get } // e.g. "/search/repositories"
    var header: HTTPTypes.HTTPFields { get }
    var queryItems: [URLQueryItem] { get }
    var body: Data? { get }
}

// MARK: - 共通のパラメータ/処理

extension NewGitHubAPIRequestProtocol {
            
    // MARK: - Computed Property
        
    /// クエリパラメータを含まないURL
    private var baseURL: URL? {
        return URL(string: "https://github.com")
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

extension GitHubAPIRequest {
    struct UpdateAccessToken {
        let clientID: String
        let clientSecret: String
        let refreshToken: String
    }
}

// MARK: - GitHubAPIRequestProtocol

extension GitHubAPIRequest.UpdateAccessToken: NewGitHubAPIRequestProtocol {
    typealias Response = FetchTokenResponse
    
    var method: HTTPTypes.HTTPRequest.Method {
        .post
    }
    
    var path: String {
        "/login/oauth/access_token"
    }
    
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.contentType] = "application/json"
        headerFields[.accept] = "application/json"
        return headerFields
    }

    var queryItems: [URLQueryItem] {
        return []
    }

    var body: Data? {
        let body: [String: String] = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]
        return try? JSONSerialization.data(withJSONObject: body, options: [])
    }
}

extension GitHubAPIRequest {
    struct FetchFirstToken {
        let clientID: String
        let clientSecret: String
        let sessionCode: String
    }
}

// MARK: - GitHubAPIRequestProtocol

extension GitHubAPIRequest.FetchFirstToken: NewGitHubAPIRequestProtocol {
    typealias Response = FetchTokenResponse
    
    var method: HTTPTypes.HTTPRequest.Method {
        .post
    }
    
    var path: String {
        "/login/oauth/access_token"
    }
    
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.contentType] = "application/json"
        headerFields[.accept] = "application/json"
        return headerFields
    }

    var queryItems: [URLQueryItem] {
        return []
    }

    var body: Data? {
        let body: [String: String] = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "code": sessionCode
        ]
        return try? JSONSerialization.data(withJSONObject: body, options: [])
    }
}
