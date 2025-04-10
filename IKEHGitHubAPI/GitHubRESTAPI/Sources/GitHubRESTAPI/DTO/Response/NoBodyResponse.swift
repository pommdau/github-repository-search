//
//  File.swift
//  GitHubRESTAPI
//
//  Created by HIROKI IKEUCHI on 2025/04/10.
//

import Foundation

/// レスポンスのbodyが空のレスポンス
public struct NoBodyResponse: Sendable {}

extension NoBodyResponse: Decodable {
    public init(from decoder: Decoder) throws {}
}

