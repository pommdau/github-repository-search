//
//  RootTabView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

struct RootTabView: View {
    
    @AppStorage("selectedTab")
    private var selectedTab = 0
        
    var body: some View {
        TabView(selection: $selectedTab) {
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
                .tag(0)
            
            SearchScreen()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            Text("hoge")
                .tabItem {
                    Label("Starred", systemImage: "star.fill")
                }
                .tag(2)
        }
    }
}

#Preview {
    RootTabView()
}
