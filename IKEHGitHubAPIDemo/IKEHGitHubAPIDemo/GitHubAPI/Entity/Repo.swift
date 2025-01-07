//
//  Repo.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/07.
//

import Foundation
import SwiftID

struct Repo: Identifiable, Equatable, Sendable, Decodable {
    struct ID: StringIDProtocol {
        let rawValue:  String
        init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    let id: ID
    let name: String  // e.g. "Tetris"
    let fullName: String  // e.g. "dtrupenn/Tetris"
    let owner: User
    let starsCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let language: String?
    let description: String?
    var subscribersCount: Int?
    var html: URL? // リポジトリのURL
    var website: URL? // 設定したホームページ
}
