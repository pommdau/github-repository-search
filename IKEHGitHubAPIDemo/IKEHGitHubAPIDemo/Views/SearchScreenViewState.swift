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
    var relationLink: RelationLink?
    var searchStatus: SearchStatus = .initial
    private(set) var searchTask: Task<(), Never>?
        
    func handleSearchKeyword() {
        if keyword.isEmpty || searchStatus == .loading {
            return
        }
                
        searchStatus = .loading
        relationLink = nil

        searchTask = Task {
            do {
                let response = try await GitHubAPIClient.shared.searchRepos(keyword: keyword)
                repos = response.items
                searchStatus = .loaded
                relationLink = response.relationLink
            } catch {
                if Task.isCancelled {
                    if repos.isEmpty {
                        searchStatus = .initial
                    } else {
                        searchStatus = .loaded
                    }
                } else {
                    searchStatus = .error(error)
                    print(error.localizedDescription)
                }
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
        searchTask = Task {
            do {
                let response = try await GitHubAPIClient.shared.searchRepos(keyword: nextLink.keyword, page: nextLink.page)
                repos.append(contentsOf: response.items)
                searchStatus = .loaded
                relationLink = response.relationLink
            } catch {
                if Task.isCancelled {
                    searchStatus = .loaded
                } else {
                    searchStatus = .error(error)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func cancelSearching() {
        searchTask?.cancel()
        searchTask = nil
    }
}
