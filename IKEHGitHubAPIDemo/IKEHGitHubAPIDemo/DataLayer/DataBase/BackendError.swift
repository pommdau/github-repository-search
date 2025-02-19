//
//  BackendError.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/19.
//

import Foundation

enum BackendError: Error {
    case writeFailed(String)
    case readFailed(String)
}

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
