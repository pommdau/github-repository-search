//
//  MessageError.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/15.
//

import Foundation

/// デバッグ向けの簡易エラー
/// - SeeAlso: [Swiftで適当なエラーを使いたいときの実装](https://ikeh1024.hatenablog.com/entry/2022/11/14/155956])
struct MessageError: Swift.Error, CustomStringConvertible, LocalizedError {
    var description: String
    var errorDescription: String? { description }
}
