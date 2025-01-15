//
//  SearchScreenViewState.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/15.
//

import Foundation

enum SearchStatus: Equatable {
    case initial /// 読み込み開始前
    case loading /// 読み込み中 or リフレッシュ中
    case loaded /// 読み込み成功
    case error(Error) ///エラー

    static func ==(lhs: SearchStatus, rhs: SearchStatus) -> Bool {
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
    var searchStatus: SearchStatus = .initial
    var relationLink: RelationLink?
    
    func handleSearchKeyword() {
        if keyword.isEmpty || searchStatus == .loading {
            return
        }
        
        self.repos = []
        self.searchStatus = .loading
        self.relationLink = nil
        print("検索するよ")
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
        
        if searchStatus == .loading {
            return
        }
        
        guard let nextLink = relationLink?.next else {
            return
        }
        searchStatus = .loading
        Task {
            do {
                let response = try await GitHubAPIClient.shared.searchRepos(keyword: nextLink.keyword, page: nextLink.page)
                repos.append(contentsOf: response.items)
                searchStatus = .loaded
                relationLink = response.relationLink
            } catch {
                print(error.localizedDescription)
                searchStatus = .error(error)
            }
        }
    }
}
