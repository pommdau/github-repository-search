//
//  GitHubAPIClientError.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/08.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

enum GitHubAPIClientError: Error {
    
    /// ログインに失敗
    case loginError(String)
    
    /// 認証関係エラー
    case oauthError(String)
    
    /// APIのリクエストの作成に失敗
    case invalidRequest
    
    /// 通信に失敗
    case connectionError(Error)
    
    /// レスポンスのデータのデコードに失敗
    case responseParseError(Error)
    
    // API実行後にエラーレスポンスを受け取った
    case apiError(GitHubAPIError)
    
    // OAuthのAPI実行後にエラーレスポンスを受け取った
    case oauthAPIError(OAuthError)
}

// MARK: - LocalizedError

extension GitHubAPIClientError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .loginError(let message):
            return "ログインに失敗しました: \(message)"
        case .oauthError(let message):
            return "APIの認証でエラーが発生しました: \(message)"
        case .invalidRequest:
            return "APIリクエストの作成に失敗しました"
        case .connectionError:
            return "通信エラー"
        case .responseParseError:
            return "データの取得に失敗しました"
        case .apiError(let gitHubAPIError):
            return "APIでエラーが発生しました: \(gitHubAPIError.localizedDescription)"
        case .oauthAPIError(let oAuthError):
            return "APIでエラーが発生しました: \(oAuthError.localizedDescription)"
        }
    }
}
