//
//  FetchStarredReposSortedBy.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/21.
//

// MARK: - 検索タイプ

import Foundation

enum FetchStarredReposSortedBy: String, CaseIterable, Identifiable, Equatable, Codable {
    case recentlyStarred = "recently_starred" // クエリで指定しない場合のデフォルト
    case recentlyActive = "recently_active"
    case leastRecentlyStarred = "least_recently_starred"
    case leastRecentlyActive = "least_recently_active"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .recentlyStarred:
            return "Recently starred"
        case .recentlyActive:
            return "Recentrly active"
        case .leastRecentlyStarred:
            return "Least recently starred"
        case .leastRecentlyActive:
            return "Least recentrly active"
        }
    }
    
    // MARK: - Query Parameter
    
    var sort: String? {
        switch self {
        case .recentlyStarred, .leastRecentlyStarred: // リポジトリへのスター日時
            return "created"
        case .recentlyActive, .leastRecentlyActive: // リポジトリへの最終Push日時
            return "updated"            
        }
    }
    
    var direction: String? {
        switch self {
        case .recentlyStarred, .recentlyActive:
            return "desc"
        case .leastRecentlyStarred, .leastRecentlyActive:
            return "asc"
        }
    }
}
