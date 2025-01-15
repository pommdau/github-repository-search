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
    var asyncRepos: AsyncValues<Repo, Error> = .initial
    var relationLink: RelationLink?
    private(set) var searchTask: Task<(), Never>?
        
    func handleSearchKeyword() {
        if case .loading = asyncRepos {
            return
        }
        
        if keyword.isEmpty {
            return
        }
                
        asyncRepos = .loading(asyncRepos.values)
        relationLink = nil

        searchTask = Task {
            do {
                let response = try await GitHubAPIClient.shared.searchRepos(keyword: keyword)
                asyncRepos = .loaded(response.items)
                relationLink = response.relationLink
            } catch {
                if Task.isCancelled {
                    if asyncRepos.values.isEmpty {
                        asyncRepos = .initial
                    } else {
                        asyncRepos = .loaded(asyncRepos.values)
                    }
                } else {
                    asyncRepos = .error(error, asyncRepos.values)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func handleSearchMore() {
        if case .loading = asyncRepos {
            return
        }
        guard let nextLink = relationLink?.next else {
            return
        }
        asyncRepos = .loadingMore(asyncRepos.values)
        searchTask = Task {
            do {
                let response = try await GitHubAPIClient.shared.searchRepos(keyword: nextLink.keyword, page: nextLink.page)
                asyncRepos = .loaded(asyncRepos.values + response.items)
                relationLink = response.relationLink
            } catch {
                if Task.isCancelled {
                    asyncRepos = .loaded(asyncRepos.values)
                } else {
                    asyncRepos = .error(error, asyncRepos.values)
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
