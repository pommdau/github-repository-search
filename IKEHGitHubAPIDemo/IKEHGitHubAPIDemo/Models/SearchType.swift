//
//  SearchType.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/15.
//


enum SearchType: String, CaseIterable, Hashable, Identifiable {
    var id: String { rawValue }
    case repo
    case user
    
    var title: String {
        switch self {
        case .repo:
            return "Repository"
        case .user:
            return "User"
        }
    }
}
