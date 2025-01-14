//
//  ContentView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/01.
//

import SwiftUI
import IKEHGitHubAPI

struct ContentView: View {
    @State private var keyword = "Swift"
    @State private var repos: [Repo] = []
    @State private var lastRepoID: Int?
    @State private var relationLink: RelationLink?
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter Keyword !", text: $keyword)
                searchButton()
            }
            .padding()

            List {
                ForEach(repos) { repo in
                    RepoCell(repo: repo)
                        .padding(.vertical, 4)
                        .onAppear() {                            
                            handleLoadMoreRepo()
                        }
                }
//                loadMoreButton()
            }
        }
    }
}

extension ContentView {
    
    @ViewBuilder
    private func searchButton() -> some View {
        Button("Search") {
            self.lastRepoID = nil
            self.relationLink = nil
            Task {
                do {
                    let response = try await GitHubAPIClient.shared.searchRepos(keyword: keyword)
                    self.repos = response.items
                    self.lastRepoID = repos.last?.id
                    self.relationLink = response.relationLink
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .disabled(keyword.isEmpty)
    }
    
//    @ViewBuilder
//    private func loadMoreButton() -> some View {
//        if let nextLink = relationLink?.next {
//            Button("Load More...") {
//                Task {
//                    do {
//                        let response = try await GitHubAPIClient.shared.searchRepos(keyword: nextLink.keyword, page: nextLink.page)
//                        self.repos.append(contentsOf: response.items)
//                        self.lastRepoID = repos.last?.id
//                        self.relationLink = response.relationLink
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//        }
//    }
    
    private func handleLoadMoreRepo() {
        
        guard
            let nextLink = relationLink?.next,
            let lastRepoID = repos.last?.id else {
            return
        }
        
        print(lastRepoID)
//        return;
        
        Task {
            do {
                let response = try await GitHubAPIClient.shared.searchRepos(keyword: nextLink.keyword, page: nextLink.page)
                self.repos.append(contentsOf: response.items)
                self.lastRepoID = repos.last?.id
                self.relationLink = response.relationLink
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
}
