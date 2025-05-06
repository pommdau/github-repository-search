//
//  SearchReposView.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import SwiftUI
import IKEHGitHubAPIClient

struct SearchReposView: View {
    
    let repoStore: RepoStoreProtocol
    
    init(repoStore: RepoStoreProtocol = RepoStore.shared) {
        self.repoStore = repoStore
    }
    
    var body: some View {
        Text("SearchReposView")
        List(repoStore.repos) { repo in
            Text(repo.name)
        }
        Button("Add") {
            Task {
                try await repoStore.addValue(Repo.Mock.random())
            }
        }
        Button("Reset") {
            Task {
                try await repoStore.deleteAllValues()
            }
        }
    }
}

#Preview {
    SearchReposView()
}

