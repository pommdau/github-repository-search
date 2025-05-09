////
////  FetchUserReposSortedBy.swift
////  GitHubRepositorySearch
////
////  Created by HIROKI IKEUCHI on 2025/05/10.
////
//
//import Foundation
//
//enum FetchUserReposSortedBy: String, CaseIterable, Identifiable, Equatable, Codable {
//    case fullName = "full_name" // クエリで指定しない場合のデフォルト
//    case updated = "updated"
//    case nameASC = "Name (A–Z)" // 名前で昇順
//    case nameDSC = "Name (Z–A)" // 名前で降順
//    
//    var id: String { rawValue }
//    
//    var title: String {
//        switch self {
//        case .recentlyStarred:
//            return "Recently starred"
//        case .recentlyActive:
//            return "Recentrly active"
//        case .leastRecentlyStarred:
//            return "Least recently starred"
//        case .leastRecentlyActive:
//            return "Least recentrly active"
//        }
//    }
//    
//    // MARK: - Query Parameter
//    
//    var sort: String? {
//        switch self {
//        case .recentlyStarred, .leastRecentlyStarred: // リポジトリへのスター日時
//            return "created"
//        case .recentlyActive, .leastRecentlyActive: // リポジトリへの最終Push日時
//            return "updated"
//        }
//    }
//    
//    var direction: String? {
//        switch self {
//        case .recentlyStarred, .recentlyActive:
//            return "desc"
//        case .leastRecentlyStarred, .leastRecentlyActive:
//            return "asc"
//        }
//    }
//}
