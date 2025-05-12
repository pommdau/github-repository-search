//
//  DebugView.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/12.
//

import SwiftUI
import IKEHGitHubAPIClient

struct DebugView: View {
    
    // MARK: - Property
        
    @State private var isRepoListExpanded: Bool = true
    @State private var showingStarredRepos: Bool = false
    
    private let repoStore: RepoStore = .shared
    private let starredRepoStore: StarredRepoStore = .shared
        
    private var repos: [Repo] {
        repoStore.valuesDic.values.sorted(by: { $0.id < $1.id })
    }
        
    private var starredRepos: [StarredRepo] {
        starredRepoStore.valuesDic.values.sorted(by: { $0.id < $1.id })
    }
    
    private var reposForDisplay: [Repo] {
        let starredRepoIDs = starredRepos.map { $0.id }
        if showingStarredRepos {
            return repos.compactMap { repo in
                starredRepoIDs.contains(repo.id) ? repo : nil
            }
        } else {
            return repos
        }
    }
    
    // MARK: - View
            
    var body: some View {
        List {
            Section("Actions") {
                resetUserDefaultsButton()
                resetReposDataButton()
            }
            
            Section("Saved Data") {
                LabeledContent("Repos Count") {
                    Text("\(reposForDisplay.count)")
                    .monospacedDigit()
                    .contentTransition(.numericText())
                }
                Toggle(isOn: $showingStarredRepos.animation()) {
                    Text("Filter Starred")
                }
                reposList()
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Debug Menu")
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private func resetUserDefaultsButton() -> some View {
        Button("Clear UserDefaults", role: .destructive) {
            guard let identifier = Bundle.main.bundleIdentifier else {
                print("Failed to clear UserDefaults. Bundle Identifier not found.")
                return
            }
            UserDefaults().removePersistentDomain(forName: identifier)
            // Storeの更新
            Task {
                try await repoStore.fetchValues()
                try await starredRepoStore.fetchValues()
            }
        }
    }
    
    @ViewBuilder
    private func resetReposDataButton() -> some View {
        Button("Clear Repos Data", role: .destructive) {
            UserDefaults.standard.removeObject(forKey: "RepoBackend-values")
            UserDefaults.standard.removeObject(forKey: "StarredRepoBackend-values")
            // Storeの更新
            Task {
                try await repoStore.fetchValues()
                try await starredRepoStore.fetchValues()
            }
        }
    }
    
    @ViewBuilder
    private func reposList() -> some View {
        DisclosureGroup(isExpanded: $isRepoListExpanded) {
            ForEach(reposForDisplay) { repo in
                HStack {
                    if starredRepos.map({ $0.repoID }).contains(repo.id) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color(uiColor: .systemYellow))
                            .accessibility(label: Text("star icon"))
                    }
                    Text("\(repo.fullName)")
                }
            }
        } label: {
            Text("Repos")
        }
    }
}

#Preview {
    DebugView()
}
