//
//  HTTPField.Name+.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/22.
//

import HTTPTypes

extension HTTPField.Name {
    static var xGithubAPIVersion: HTTPField.Name {
        // 適切な文字列を入れている限りは必ず成功する
        guard let name = Self("X-GitHub-Api-Version") else {
            fatalError("Failed in HTTPField.Name.xGithubAPIVersion")
        }
        return name
    }
}
