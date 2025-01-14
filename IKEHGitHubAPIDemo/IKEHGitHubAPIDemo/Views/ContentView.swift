//
//  ContentView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/01.
//

import SwiftUI
import IKEHGitHubAPI

struct SampleView: View {
    var body: some View {
        Text("sample")
    }
}

struct ContentView: View {
    @State private var keyword = "Swift"
//    @State private var repos: AsyncValues<Repo, GitHubAPIError> = .initial
//    @State private var repos: AsyncValues<Repo, GitHubAPIError> = .loaded(Repo.sampleData)
    @State private var repos: AsyncValues<Repo, GitHubAPIError> = .loading(Array(Repo.sampleData[0..<1]))
//    @State private var repos: [Repo] = []
    @State private var lastRepoID: Int?
    @State private var relationLink: RelationLink?
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter Keyword !", text: $keyword)
                searchButton()
            }
            .padding()
            
            AsyncValueView(values: repos) { repos in
                List(repos) { repo in
                    RepoCell(repo: repo)
                        .padding(.vertical, 4)
                }
            } initialView: {
                Text("検索してください！")
            } loadingView: { repos in
                List {
                    ForEach(repos) { repo in
                        RepoCell(repo: repo)
                            .padding(.vertical, 4)
                    }
                    ProgressView()
                        .padding(.vertical, 8)
                }
            } errorView: { error, repos in
                Text(error.localizedDescription)
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
//                    let response = try await GitHubAPIClient.shared.searchRepos(keyword: keyword)
//                    self.repos = response.items
//                    self.lastRepoID = repos.last?.id
//                    self.relationLink = response.relationLink
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
        
//        guard
//            case let repos =
//            let nextLink = relationLink?.next,
//            let lastRepoID = repos.last?.id else {
//            return
//        }
//        
//        print(lastRepoID)
////        return;
//        
//        Task {
//            do {
//                let response = try await GitHubAPIClient.shared.searchRepos(keyword: nextLink.keyword, page: nextLink.page)
//                self.repos.append(contentsOf: response.items)
//                self.lastRepoID = repos.last?.id
//                self.relationLink = response.relationLink
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
    }
}

#Preview {
    ContentView()
}
