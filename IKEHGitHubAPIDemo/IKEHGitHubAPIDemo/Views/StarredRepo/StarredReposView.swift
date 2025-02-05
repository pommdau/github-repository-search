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
        Group {
            if state.loginUser == nil {
                // 未ログイン時
                LoginView(namespace: namespace) {
                    // コールバックURLはProfile側で受け取る
                    state.handleLogInButtonTapped()
                }
            } else {
                // ログイン時
                NavigationStack {
                    StarredReposList(asyncRepos: state.asyncRepos)
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
        .errorAlert(error: $state.error)
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

// MARK: - Content


// MARK: - Preview

#Preview("initial") {
    NavigationStack {
        StarredReposView()
    }
}
