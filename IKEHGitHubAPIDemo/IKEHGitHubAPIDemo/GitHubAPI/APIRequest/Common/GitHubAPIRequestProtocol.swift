//
//  NewGitHubAPIRequestProtocol.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/21.
//

import Foundation
import HTTPTypes

/// レスポンスのエラー判定のタイプ
enum ResponseFailType {
    case statusCode // ステータスコードが200番台でなければ失敗
    case responseBody // レスポンスボディがエラー形式であれば失敗(OAuth2.0認証など)
}

// MARK: - GitHubAPIRequestProtocol

protocol GitHubAPIRequestProtocol {
    
    // MARK: Response
    associatedtype Response: Decodable // レスポンスのデータモデル
    var responseFailType: ResponseFailType { get }
            
    // MARK: URL
    
    var baseURL: URL? { get } // e.g. "https://api.github.com"
    var path: String { get } // e.g. "/search/repositories"
    var queryItems: [URLQueryItem] { get }
    
    // MARK: Data
    
    var method: HTTPRequest.Method { get }
    var header: HTTPTypes.HTTPFields { get }
    var body: Data? { get }
}

// MARK: - 共通処理

extension GitHubAPIRequestProtocol {
    
    var responseFailType: ResponseFailType {
        .statusCode
    }
        
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
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        return components.url
    }
        
    /// プロパティの値からHTTPRequestを作成
    func buildHTTPRequest() -> HTTPRequest? {
        guard let url else {
            return nil
        }
        print(url.absoluteString)
        return HTTPRequest(
            method: method,
            url: url,
            headerFields: header
        )
    }
}
