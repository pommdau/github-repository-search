//
//  StarredReposResponse.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/26.
//

import Foundation

struct StarredReposResponse: Sendable, Decodable {

    // MARK: - レスポンスのBodyをDecodeして取得される情報
    
    let repos: [Repo]
    
    // MARK: - レスポンスのHeaderから所得される情報
    
    var relationLink: RelationLink? // ページング情報
}
