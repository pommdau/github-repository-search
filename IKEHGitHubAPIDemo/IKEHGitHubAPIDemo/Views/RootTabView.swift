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
            Tab("Profile", systemImage: "person.crop.circle.fill", value: 0) {
                ProfileScreen()
            }
            
            Tab("Search", systemImage: "magnifyingglass", value: 1) {
                SearchScreen()
            }
            
            Tab("Starred", systemImage: "star.fill", value: 2) {
                Text("Starred Screen")
            }
            
            Tab("Debug", systemImage: "ladybug.fill", value: 3) {
                LoginDebugView()
            }
        }
    }
}

#Preview {
    RootTabView()
}
