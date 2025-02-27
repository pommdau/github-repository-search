//
//  LoginUserReposView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/27.
//

import SwiftUI

struct LoginUserReposView: View {
            
    // MARK: - Property
    
//    @State private var state: ProfileViewState = .init()
    @State private var asyncValues: AsyncValues<Repo, Error> = .loaded(Repo.Mock.random(count: 10))
        
    // MARK: - View
    
    var body: some View {
        NavigationStack {
            AsyncValuesView(
                asyncValues: asyncValues,
                initialView: ProgressView(),
                loadingView: ProgressView(),
                dataView: { repos in
                    ForEach(repos) { repo in
                        NavigationLink {
                            RepoDetailsView(repoID: repo.id)
                        } label: {
                            RepoCell(repo: repo)
                        }
                    }
                },
                noResultView: Text("no result"),
                loadingMoreProgressView: ProfileView(),
                handlePullToRefresh: nil
            )
        }
    }
}

#Preview {
    LoginUserReposView()
}

