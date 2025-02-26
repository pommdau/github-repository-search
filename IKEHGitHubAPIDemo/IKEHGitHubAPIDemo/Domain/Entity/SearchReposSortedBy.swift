//
//  SearchReposSortBy.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/21.
//

import Foundation

// Webの検索を参考に
// https://github.com/search?q=Swift&type=repositories
enum SearchReposSortedBy: String, CaseIterable, Identifiable, Equatable {
    case bestMatch
    case mostStars
    case fewestStars
    case mostForks
    case fewestForks
    case recentryUpdated
    case leastRecentlyUpdated
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .bestMatch:
            return "Best match"
        case .mostStars:
            return "Most stars"
        case .fewestStars:
            return "Fewest stars"
        case .mostForks:
            return "Most forks"
        case .fewestForks:
            return "Fewest forks"
        case .recentryUpdated:
            return "Recently updated"
        case .leastRecentlyUpdated:
            return "Least recently updated"
        }
    }
    
    // MARK: - Query Parameter
    
    var sort: String? {
        switch self {
        case .bestMatch:
            return nil
        case .mostStars, .fewestStars:
            return "stars"
        case .mostForks, .fewestForks:
            return "forks"
        case .recentryUpdated, .leastRecentlyUpdated:
            return "updated"
        }
    }
    
    var order: String? {
        switch self {
        case .bestMatch:
            return nil
        case .mostStars, .mostForks, .recentryUpdated:
            return "desc"
        case .fewestStars, .fewestForks, .leastRecentlyUpdated:
            return "asc"
        }
    }
}
