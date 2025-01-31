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
    }
    
    // searchReposで取得される情報
    let rawID: Int
    let name: String  // e.g. "Tetris"
    let fullName: String  // e.g. "dtrupenn/Tetris"
    let owner: User
    let starsCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let language: String?
    let htmlPath: String  // リポジトリのURL
    let websitePath: String?  // 設定したホームページ
    let description: String?
    
    // その他補完されて取得される情報
    var subscribersCount: Int?
            
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
    static func createRandom() -> Repo {
        let randomID = Int.random(in: 1000...9999)
        let randomName = ["Tetris", "Chess", "Snake", "Pong", "Breakout"].randomElement()!
        let randomOwner = User.createRandom()
        let randomLanguage = ["Swift", "Python", "JavaScript", "C++", "Rust"].randomElement()
        
        return Repo(
            rawID: randomID,
            name: randomName,
            fullName: "\(randomOwner.name)/\(randomName)",
            owner: randomOwner,
            starsCount: Int.random(in: 0...10000),
            watchersCount: Int.random(in: 0...5000),
            forksCount: Int.random(in: 0...3000),
            openIssuesCount: Int.random(in: 0...200),
            language: randomLanguage,
            htmlPath: "https://github.com/",
            websitePath: Bool.random() ? "https://\(randomName.lowercased()).com" : nil,
            description: "This is a random repository.",
            subscribersCount: Int.random(in: 0...1000)
        )
    }
}
