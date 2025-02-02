//
//  RootTabView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

enum TabType: String {
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

struct RootTabView: View {
    
    @AppStorage("roottabview-selected-tab")
    private var selectedTab: TabType = .profile
        
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(TabType.profile.title, systemImage: TabType.profile.icon, value: TabType.profile) {
                ProfileView()
            }

            Tab(TabType.search.title, systemImage: TabType.search.icon, value: TabType.search) {
                SearchScreen()
            }
            
            Tab(TabType.starredRepos.title, systemImage: TabType.starredRepos.icon, value: TabType.starredRepos) {
                StarredRepoView()
            }
            
            Tab(TabType.debug.title, systemImage: TabType.debug.icon, value: TabType.debug) {
                LoginDebugView()
            }
        }
    }
}

#Preview {
    RootTabView()
}
