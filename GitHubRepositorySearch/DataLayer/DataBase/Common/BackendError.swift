//
//  BackendError.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/19.
//

import Foundation

enum BackendError: Error {
    /// データの書き込みに失敗した場合
    case writeFailed(String)
    /// データの読み込みに失敗した場合
    case readFailed(String)
}

// MARK: - LocalizedError

extension BackendError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .writeFailed(let message):
            return "Backend Write Failed: \(message)"
        case .readFailed(let message):
            return "Bacnend Read Failed: \(message)"
        }
    }
}
