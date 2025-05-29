//
//  RootTabView.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import SwiftUI

struct RootTabView: View {
            
    @State private var state: RootTabViewState = .init()
        
    var body: some View {
        TabView(selection: $state.selectedTab) {
            Tab(RootTabType.profile.title, systemImage: RootTabType.profile.icon, value: RootTabType.profile) {
                ProfileView()
            }

            Tab(RootTabType.search.title, systemImage: RootTabType.search.icon, value: RootTabType.search) {
                SearchReposView()
            }
#if DEBUG
            Tab(RootTabType.debug.title, systemImage: RootTabType.debug.icon, value: RootTabType.debug) {
                DebugView()
            }
#endif
        }
        .onOpenURL { url in
            state.handleOnCallbackURL(url)
        }
    }
}

#Preview {
    RootTabView()
}
