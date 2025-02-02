//
//  RootTabView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

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
                StarredReposView()
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
