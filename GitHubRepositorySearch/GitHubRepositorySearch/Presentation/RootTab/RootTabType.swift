//
//  RootTabType.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import Foundation

enum RootTabType: String {
    case profile
    case search
    case debug
    
    var title: String {
        switch self {
        case .profile:
            "Profile"
        case .search:
            "Search"
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
        case .debug:
            "ladybug.fill"
        }
    }
}
