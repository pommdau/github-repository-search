//
//  SearchResultView2.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/15.
//

import SwiftUI

struct SearchResultView: View {
    let repos: [Repo]
    let status: SearchStatus
    var bottomCellOnAppear: (Int) -> Void = { _ in }
    
    var body: some View {
        VStack {
            switch status {
            case .initial:
                Text("Search GitHub Repositories!")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            case .loading, .loaded, .error:
                dataView(repos: repos, status: status)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private func dataView(repos: [Repo], status: SearchStatus) -> some View {
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
                                bottomCellOnAppear(repo.id)
                            }
                        }
                }
                if status == .loading {
                    ProgressView("searching...")
                        .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
                        .frame(maxWidth: .infinity, alignment: .center)
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
    SearchResultView(repos: Array(Repo.sampleData[0...6]),
                      status: .loaded)
}

#Preview("SearchResultView2") {
    NavigationStack {
        SearchResultView(repos: Array(Repo.sampleData[0...1]),
                          status: .loading)
        
    }
    .searchable(text: .constant("hoge"), prompt: "Enter Keyword")
}
