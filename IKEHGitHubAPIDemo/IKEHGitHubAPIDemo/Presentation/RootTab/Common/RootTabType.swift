//
//  TabType.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/03.
//

import Foundation

enum RootTabType: String {
    case profile
    case search
    case starredRepos
    case debug
    
    var title: String {
        switch self {
        case .profile:
            "Profile"
        case .search:
            "Search"
        case .starredRepos:
            "Starred"
        case .debug:
            "Debug"
        }
    }
    
    var icon: String {
        switch self {
        case .profile:
            "person.crop.circle.fill"
        case .search:
            "magnifyingglass"
        case .starredRepos:
            "star.fill"
        case .debug:
            "ladybug.fill"
        }
    }
}
