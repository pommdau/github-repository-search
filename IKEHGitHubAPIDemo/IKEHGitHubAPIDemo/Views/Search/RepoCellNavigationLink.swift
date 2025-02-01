//
//  RepoCellLink.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/01.
//

import SwiftUI

struct RepoCellNavigationLink: View {
    
    @Namespace var repoCellLinkNamespace
    
    let repo: Repo
    
    var body: some View {
        NavigationLink {
            RepoDetailsView(repoID: repo.id)
                .navigationBarBackButtonHidden()
                .navigationTransition(.zoom(sourceID: "\(repo.id)", in: repoCellLinkNamespace))
        } label: {
            RepoCell(repo: repo)
                .matchedTransitionSource(id:"\(repo.id)", in: repoCellLinkNamespace)
        }
    }
}

#Preview {
    NavigationStack {
        List {
            RepoCellNavigationLink(repo: Repo.Mock.createRandom())
        }
    }
}
