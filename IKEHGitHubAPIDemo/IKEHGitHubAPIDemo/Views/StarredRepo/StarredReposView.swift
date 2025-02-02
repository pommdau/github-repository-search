//
//  StarredReposView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/25.
//

import SwiftUI

struct StarredReposView: View {
    
    // MARK: - Property
        
    @Namespace private var namespace
    @State private var state: StarredReposViewState = .init()
    
    // MARK: - LifeCycle
    
    // MARK: - View
    
    var body: some View {
        if state.loginUser == nil {
            // 未ログイン時
            ZStack {
                List {
                    Button("Fetch") {
                        state.handleFetchingStarredRepos()
                    }
                    Button("Fetch More") {
                        state.fetchStarredReposMore()
                    }
                }
                LoginView(namespace: namespace)
            }
        } else {
            // ログイン時
            NavigationStack {
                StarredReposList(asyncRepos: state.asyncRepos)
                    .errorAlert(error: $state.error)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Starred Repositories")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            toolbarItemContentSortedBy()
                        }
                    }
            }
            .onAppear {
                state.onAppear()
            }
        }
    }
        
    @ViewBuilder
    private func toolbarItemContentSortedBy() -> some View {
        Menu {
            Picker("Sorted By", selection: $state.sortedBy) {
                ForEach(GitHubAPIRequest.StarredReposRequest.SortBy.allCases) { type in
                    Text(type.title).tag(type)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onChange(of: state.sortedBy) { _, _ in
                state.handleSortedByChanged()
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
    }
}

// MARK: - Preview

#Preview("initial") {
    NavigationStack {
        StarredReposView()
    }
}
