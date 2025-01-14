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
            SearchResultView2(repos: viewState.repos, status: viewState.searchStatus) { _ in
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

enum SearchingStatus: Equatable {
    case initial /// 読み込み開始前
    case loading /// 読み込み中 or リフレッシュ中
    case loaded /// 読み込み成功
    case error(Error) ///エラー

    static func ==(lhs: SearchingStatus, rhs: SearchingStatus) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial),
             (.loading, .loading),
             (.loaded, .loaded):
            return true
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

@MainActor
@Observable
final class SearchScreenViewState {
    var keyword: String = "Swift"
    var repos: [Repo] = []
    var searchStatus: SearchingStatus = .initial
    var relationLink: RelationLink?
    
    func handleSearchKeyword() {
        self.repos = []
        self.searchStatus = .loading
        self.relationLink = nil
        Task {
            do {
                let response = try await GitHubAPIClient.shared.searchRepos(keyword: keyword)
                self.repos = response.items
                self.searchStatus = .loaded
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
        searchStatus = .loading
        Task {
            do {
                let response = try await GitHubAPIClient.shared.searchRepos(keyword: nextLink.keyword, page: nextLink.page)
                repos.append(contentsOf: response.items)
                self.searchStatus = .loaded
                relationLink = response.relationLink
            } catch {
                print(error.localizedDescription)
                searchStatus = .error(error)
            }
        }
    }
}

struct SearchResultView2: View {
    let repos: [Repo]
    let status: SearchingStatus
    var bottomCellDidAppear: (Int) -> Void = { _ in }
    
    var body: some View {
        VStack {
            switch status {
            case .initial:
                Text("Search GitHub Repositories!")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            case .loading, .loaded:
                dataView(repos: repos, status: status)
            case .error(let error):
                Text(error.localizedDescription)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private func dataView(repos: [Repo], status: SearchingStatus) -> some View {
        Group {
            if status != .loading && repos.isEmpty {
                Text("No Result")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                List {
                    ForEach(repos) { repo in
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
                    if status == .loading {
                        ProgressView()
                            .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
                            .frame(maxWidth: .infinity, alignment: .center)
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
    
//    @ViewBuilder
//    private func progressView() -> some View {
//        switch asyncRepos {
//        case .loading(_):
//            ProgressView()
//        default:
//            EmptyView()
//        }
//    }
}

#Preview("SearchResultView2") {
    SearchResultView2(repos: Array(Repo.sampleData[0...6]),
                      status: .loaded)
}

#Preview("SearchResultView2") {
    SearchResultView2(repos: Array(Repo.sampleData[0...5]),
                      status: .loading)
}



#Preview {
//    SearchResultView2(asyncRepos: .loading(Array(Repo.sampleData[0...2])))
}

#Preview {
    SearchScreen()
}
