//
//  HTTPField+ConstantValue.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import HTTPTypes

extension HTTPField {
    enum ConstValue {
        static let applicationJSON = "application/json"
        static let applicationVndGitHubJSON = "application/vnd.github+json"
        static let xGitHubAPIVersion = "2022-11-28"
    }
}
