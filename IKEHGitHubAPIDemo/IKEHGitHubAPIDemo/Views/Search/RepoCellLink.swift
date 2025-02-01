//
//  RepoCellLink.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/01.
//

import SwiftUI

struct RepoCellLink: View {
    
    @Namespace var repoCellLinkNamespace
    
    let repo: Repo
    
    var body: some View {
        NavigationLink {
            RepoDetailsView(repoID: repo.id)
                .navigationTransition(.zoom(sourceID: "\(repo.id)-repository", in: repoCellLinkNamespace))
        } label: {
            RepoCell(repo: repo)
                .matchedTransitionSource(id:"\(repo.id)-repository", in: repoCellLinkNamespace)
//                .padding(.vertical, 4)
        }
    }
}

#Preview {
    NavigationStack {
        List {
            RepoCellLink(repo: Repo.sampleData.first!)
        }
    }
}
