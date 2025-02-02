//
//  Repo.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/07.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

// アーキテクチャのRepositoryと区別するためRepoの名称を使う
// TODO: remove Equatable
struct Repo: GitHubDTO, Equatable {
    
    // MARK: - Decode Result
    
    private enum CodingKeys: String, CodingKey {
        case rawID = "id"
        case name
        case fullName = "full_name"
        case owner
        case starsCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case language
        case htmlPath = "html_url"
        case websitePath = "homepage"
        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    // searchReposで取得される情報
    let rawID: Int
    var name: String  // e.g. "Tetris"
    var fullName: String  // e.g. "dtrupenn/Tetris"
    var owner: User
    var starsCount: Int
    var watchersCount: Int
    var forksCount: Int
    var openIssuesCount: Int
    var language: String?
    var htmlPath: String  // リポジトリのURL
    var websitePath: String?  // 設定したホームページ
    var description: String?
    var createdAt: String // e.g. "2015-10-23T21:15:07Z",
    var updatedAt: String // e.g. "2025-02-02T06:17:34Z",
    
    // MARK: その他補完されて取得される情報
    
    var subscribersCount: Int?
        
    // MARK: Starred
    
    var starredAt: String? // e.g. "2024-12-17T01:54:20Z"
    var isStarred: Bool = false
            
    // MARK: - Computed Property

    var id: SwiftID<Self> { "\(rawID)" }
    
    var htmlURL: URL? {
        URL(string: htmlPath)
    }

    var websiteURL: URL? {
        guard let websitePath else {
            return nil
        }
        return URL(string: websitePath)
    }

    mutating func update(_ detail: RepoDetails) {
        self.subscribersCount = detail.subscribersCount
    }
}

extension Repo {
    
}
