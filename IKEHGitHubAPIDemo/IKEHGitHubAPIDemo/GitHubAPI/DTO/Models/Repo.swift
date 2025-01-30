//
//  Repo.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/07.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import SwiftID

// アーキテクチャのRepositoryと区別するためRepoの名称を使う
struct Repo: Sendable, Identifiable, Codable, Equatable {
    
    struct ID: StringIDProtocol {
        let rawValue:  String
        init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
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

    var id: ID { "\(rawID)" }
    
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
