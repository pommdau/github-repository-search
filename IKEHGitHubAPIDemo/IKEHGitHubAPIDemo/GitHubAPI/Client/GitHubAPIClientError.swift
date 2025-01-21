//
//  GitHubAPIClientError.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/08.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

enum GitHubAPIClientError: Error {
    
    // ログインに失敗
    case loginError
    
    // APIのリクエストの作成に失敗
    case invalidRequest
    
    // 通信に失敗
    case connectionError(Error)

    // レスポンスの解釈に失敗
    case responseParseError(Error)

    // APIからエラーレスポンスを受け取った
    case apiError(GitHubAPIError)
}

extension GitHubAPIClientError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .loginError:
            return "ログインに失敗しました";
        case .invalidRequest:
            return "APIリクエストの作成に失敗しました";
        case .connectionError:
            return "通信エラー";
        case .responseParseError:
            return "データの取得に失敗しました";
        case .apiError(let gitHubAPIError):
            return "APIエラー: \(gitHubAPIError.message)"
        }
    }
}
