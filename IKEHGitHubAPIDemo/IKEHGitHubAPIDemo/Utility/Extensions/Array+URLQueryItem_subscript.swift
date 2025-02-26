//
//  Array+URLQueryItem_subscript.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/26.
//

import Foundation

extension Array where Element == URLQueryItem {
    subscript(_ key: String) -> String? {
        first(where: { $0.name == key })?.value
    }
}
