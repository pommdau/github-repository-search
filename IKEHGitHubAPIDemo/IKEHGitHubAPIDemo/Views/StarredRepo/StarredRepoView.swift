//
//  StarredRepoView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/25.
//

import SwiftUI

@MainActor @Observable
final class StarredRepoViewState {
    let githubAPIClient: GitHubAPIClient
    let repoStore: RepoStore
    var sortedBy: GitHubAPIRequest.StarredReposRequest.SortBy = .recentryStarred
    
//    private var asyncRepoIDs: AsyncValues<Repo.ID, Error> = .initial

    var repos: [Repo] {
        repoStore.repos
    }
    
    init(githubAPIClient: GitHubAPIClient = .shared, repoStore: RepoStore = .shared) {
        self.githubAPIClient = githubAPIClient
        self.repoStore = repoStore
    }
    
//    convenience init() {
//        self.init(starredRepoStore: StarredRepoStore.shared)
//    }
//        

    
    func fetchRepos() async {
        do {
            let repos = try await githubAPIClient.fetchStarredRepos()
            try await repoStore.addValues(repos)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func onAppear() {
        Task {
            do {
                try await repoStore.fetchValues()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct StarredRepoView: View {
    
    @Namespace var namespace
    @State private var state: StarredRepoViewState = .init()
        
    var body: some View {
        NavigationStack {
            List {
//                Button("Fetch") {
//                    Task {
//                        do {
//                            try await state.fetchRepos()
//                        } catch {
//                            print(error.localizedDescription)
//                        }
//                    }
//                }
//                
//                Button("Add") {
////                    viewState.handleAddButtonTapped()
//                }
//                
//                Button("Delete All") {
//                    Task {
//                        try? await state.repoStore.deleteAllValues()
//                    }
//                }
                
                ForEach(state.repos) { repo in
                    NavigationLink {
                        RepoDetailsView(repoID: repo.id)
                            .navigationBarBackButtonHidden()
                            .navigationTransition(.zoom(sourceID: "\(repo.id)", in: namespace))
                    } label: {
                        RepoCell(repo: repo)
                            .matchedTransitionSource(id:"\(repo.id)", in: namespace)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Starred Repositories")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sorted By", selection: $state.sortedBy) {
                            ForEach(GitHubAPIRequest.StarredReposRequest.SortBy.allCases) { type in
                                /// 選択項目の一覧
                                Text(type.title).tag(type)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .onChange(of: state.sortedBy) { _, _ in
//                            state.handleSortedByChanged()
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
        }
        .onAppear {
            state.onAppear()
        }
    }
}

#Preview {
    StarredRepoView()
}
