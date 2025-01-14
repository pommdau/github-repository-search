//
//  SearchScreen.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/14.
//

import SwiftUI

struct SearchScreen: View {
    
    @State private var viewState = SearchScreenViewState()
    
    var body: some View {
        NavigationStack {
            SearchResultView2(asyncRepos: viewState.repos) { _ in
                // 一番下のセルが表示された場合
                viewState.handleSearchMore()
            }
        }
        .searchable(text: $viewState.keyword, prompt: "Enter Keyword")
        .onSubmit(of: .search) {
            viewState.handleSearchKeyword()
        }
    }
}

@MainActor
@Observable
final class SearchScreenViewState {
    var keyword: String = "Swift"
    var repos: AsyncValues<Repo, Error> = .initial
//    private(set) var repos: AsyncValues<Repo, GitHubAPIError> = .loading([])
    var relationLink: RelationLink?
    
    func handleSearchKeyword() {
        self.repos = .loading([])
        self.relationLink = nil
        Task {
            do {
                let response = try await GitHubAPIClient.shared.searchRepos(keyword: keyword)
                let repos = response.items
                self.repos = .loaded(repos)
                self.relationLink = response.relationLink
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func handleSearchMore() {
        guard let nextLink = relationLink?.next else {
            return
        }
        repos = .loading(repos.values)
        Task {
            do {
                let response = try await GitHubAPIClient.shared.searchRepos(keyword: nextLink.keyword, page: nextLink.page)
                repos = .loaded(repos.values + response.items)
                relationLink = response.relationLink
            } catch {
                print(error.localizedDescription)
                repos = .error(error, repos.values)
            }
        }
    }
}

struct SearchResultView2: View {
    let asyncRepos: AsyncValues<Repo, Error>
    var bottomCellDidAppear: (Int) -> Void = { _ in }
    
    var body: some View {
        VStack {
            AsyncValuesView(values: asyncRepos) { repos in
                dataView(repos: repos)
            } initialView: {
                Text("Search GitHub Repositories!")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } loadingView: { repos in
                loadingView(repos: repos)
            } errorView: { error, repos in
                Text(error.localizedDescription)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private func dataView(repos: [Repo]) -> some View {
        Group {
            if repos.isEmpty {
                Text("No Result")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                List(repos) { repo in
                    RepoCell(repo: repo)
                        .padding(.vertical, 4)
                        .onAppear {
                            guard let lastRepo = repos.last else {
                                return
                            }
                            if lastRepo.id == repo.id {
                                bottomCellDidAppear(repo.id)
                            }
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    private func loadingView(repos: [Repo]) -> some View {
        List {
            Section {
                ForEach(repos) { repo in
                    RepoCell(repo: repo)
                        .padding(.vertical, 4)
                }
            }
            ProgressView()
                .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}


#Preview {
    SearchScreen()
}

#Preview {
    SearchResultView2(asyncRepos: .loading(Array(Repo.sampleData[0...2])))
}
