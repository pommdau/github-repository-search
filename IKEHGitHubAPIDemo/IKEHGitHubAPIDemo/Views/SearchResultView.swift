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

struct SearchResultView: View {
    
    // isSearchingは.searchableと同じViewで使用できないため、本Viewを切り出している
    @Environment(\.isSearching) private var isSearching: Bool
    @Environment(\.dismissSearch) private var dismissSearch
    
    let keyword: String
    
    @State private var repos: AsyncValues<Repo, GitHubAPIError> = .initial
//        @State private var repos: AsyncValues<Repo, GitHubAPIError> = .loading([])
//    @State private var repos: AsyncValues<Repo, GitHubAPIError> = .loaded(Repo.sampleData)
//    @State private var repos: AsyncValues<Repo, GitHubAPIError> = .loaded(Array(Repo.sampleData[0..<2]))
//    @State private var repos: AsyncValues<Repo, GitHubAPIError> = .loading(Array(Repo.sampleData[0..<2]))
//    @State private var repos: [Repo] = []
    @State private var lastRepoID: Int?
    @State private var relationLink: RelationLink?
    
    var body: some View {
        AsyncValuesView(values: repos) { repos in
            List(repos) { repo in
                RepoCell(repo: repo)
                    .padding(.vertical, 4)
            }
        } initialView: {
            Text("Search GitHub Repositories!")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        } loadingView: { repos in
            VStack {
                List(repos) { repo in
                    RepoCell(repo: repo)
                        .padding(.vertical, 4)
                    Divider()
                }
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.vertical, 8)
            }
        } errorView: { error, repos in
            Text(error.localizedDescription)
        }
        .onChange(of: isSearching) { oldValue, newValue in
            print(newValue)
        }
    }
}

extension SearchResultView {
    
    @ViewBuilder
    private func searchButton() -> some View {
        Button("Search") {
            self.repos = .loading([])
            self.lastRepoID = nil
            self.relationLink = nil
            Task {
                do {
                    let response = try await GitHubAPIClient.shared.searchRepos(keyword: keyword)
                    let repos = response.items
                    self.repos = .loaded(repos)
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
    SearchResultView(keyword: "Swift")
}
