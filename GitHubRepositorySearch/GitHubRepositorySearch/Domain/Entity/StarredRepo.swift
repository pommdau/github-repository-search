//
//  StarredRepo.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/07.
//

import Foundation
import IKEHGitHubAPIClient

struct StarredRepo: Identifiable, Equatable, Sendable, Codable {
    
    /// For Identifiable
    var id: Repo.ID { repoID }
    
    /// リポジトリのID
    let repoID: Repo.ID
    
    /// スター日時
    var starredAt: String? // e.g. "2024-12-17T01:54:20Z"
    
    /// スター済みかどうか
    var isStarred: Bool = false
}
