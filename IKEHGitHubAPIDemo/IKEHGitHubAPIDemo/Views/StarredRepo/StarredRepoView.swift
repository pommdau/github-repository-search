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
    
    init(githubAPIClient: GitHubAPIClient = .shared, repoStore: RepoStore = .shared) {
        self.githubAPIClient = githubAPIClient
        self.repoStore = repoStore
    }
    
//    convenience init() {
//        self.init(starredRepoStore: StarredRepoStore.shared)
//    }
//        
    var repos: [Repo] {
        repoStore.repos
    }
    
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
    
    @State private var state: StarredRepoViewState = .init()
    
    var body: some View {
        NavigationStack {
            List {
                Button("Fetch") {
                    Task {
                        do {
                            try await state.fetchRepos()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                
                Button("Add") {
//                    viewState.handleAddButtonTapped()
                }
                
                Button("Delete All") {
                    Task {
                        try? await state.repoStore.deleteAllValues()
                    }
                }
                
                ForEach(state.repos) { repo in
                    NavigationLink {
                        RepoDetailsView(repo: repo)
                    } label: {
                        RepoCell(repo: repo)
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
