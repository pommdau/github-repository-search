//
//  RootTabView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

struct RootTabView: View {
    
    @AppStorage("roottabview-selected-tab")
    private var selectedTab: RootTabType = .profile
    
    @State private var state: RootTabViewState = .init()
        
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(RootTabType.profile.title, systemImage: RootTabType.profile.icon, value: RootTabType.profile) {
                ProfileView()
            }

            Tab(RootTabType.search.title, systemImage: RootTabType.search.icon, value: RootTabType.search) {
                SearchScreen()
            }
            
            Tab(RootTabType.starredRepos.title, systemImage: RootTabType.starredRepos.icon, value: RootTabType.starredRepos) {
                StarredReposView()
            }
            
            Tab(RootTabType.debug.title, systemImage: RootTabType.debug.icon, value: RootTabType.debug) {
                LoginDebugView()
            }
        }
        .onOpenURL { url in
            state.handleOnCallbackURL(url)
        }
    }
}

#Preview {
    RootTabView()
}
