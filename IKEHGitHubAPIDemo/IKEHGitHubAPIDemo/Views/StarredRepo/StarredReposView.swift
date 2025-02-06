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
                NewLoginView(namespace: namespace)
            } else {
                // ログイン時
                NavigationStack {
                    starredReposResult()
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
                    Text(type.title)
                        .tag(type)
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

// MARK: - StarredReposResult

extension StarredReposView {
    @ViewBuilder
    private func starredReposResult() -> some View {
        List {
            switch state.asyncRepos {
            case .initial, .loading:
                skeltonView()
            case .loaded, .loadingMore, .error:
                if state.showNoResultView {
                    noResultView()
                } else {
                    starredReposList()
                    if case .loadingMore = state.asyncRepos {
                        lodingMoreProgressView()
                    }
                }
            }
        }
//        .matchedGeometryEffect(id: ProfileView.NamespaceID.image1, in: namespace)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Starred Repositories")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                toolbarItemContentSortedBy()
            }
        }
    }
    
    @ViewBuilder
    private func skeltonView() -> some View {
        ForEach(0..<3, id: \.self) { _ in
            RepoCell(repo: Repo.Mock.sampleDataForReposCellSkelton)
                .redacted(reason: .placeholder)
                .shimmering()
                .id(UUID())
        }
    }
    
    @ViewBuilder
    private func noResultView() -> some View {
        VStack {
            Image(systemName: "star.slash")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.secondary)
                .frame(width: 36)
            Text("There are no starred repositories")
                .lineLimit(1)
                .bold()
        }
        .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    private func starredReposList() -> some View {
        ForEach(state.asyncRepos.values) { repo in
            NavigationLink {
                RepoDetailsView(repoID: repo.id)
                    .navigationBarBackButtonHidden()
                    .navigationTransition(.zoom(sourceID: "\(repo.id)", in: namespace))
            } label: {
                RepoCell(repo: repo)
                    .matchedTransitionSource(id:"\(repo.id)", in: namespace)
                    .onAppear {
                        state.onAppearRepoCell(id: repo.id)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func lodingMoreProgressView() -> some View {
        // https://zenn.dev/oka_yuuji/articles/807a9662f087f7
        ProgressView("Loading...")
            .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
            .frame(maxWidth: .infinity, alignment: .center)
            .id(UUID())
    }
}

// MARK: - Preview

#Preview("initial") {
    NavigationStack {
        StarredReposView()
    }
}
