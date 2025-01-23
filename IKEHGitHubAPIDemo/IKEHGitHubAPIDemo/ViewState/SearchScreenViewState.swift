//
//  SearchScreenViewState.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/15.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class SearchScreenViewState {
    var searchText: String = "Swift"
    var sortedBy: GitHubAPIRequest.NewSearchRequest.SortBy = .bestMatch
    
    private(set) var asyncRepos: AsyncValues<Repo, Error> = .initial
    private var relationLink: RelationLink?
    private(set) var searchTask: Task<(), Never>?
        
    func handleSearchText() {
        
        // すでに検索中であれば何もしない
        if case .loading = asyncRepos {
            return
        }
        
        // 検索ワード未入力の場合
        if searchText.isEmpty {
            return
        }
        
        asyncRepos = .loading(asyncRepos.values)
        relationLink = nil

        searchTask = Task {
            do {
                let response = try await GitHubAPIClient.shared.searchRepos(searchText: searchText, sortedBy: sortedBy)
                withAnimation {
                    asyncRepos = .loaded(response.items)
                }
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
        
        // 他でダウンロード処理中であればキャンセル
        switch asyncRepos {
        case .loading, .loadingMore:
            return
        default:
            break
        }
        
        // リンク情報がなければ何もしない
        guard let nextLink = relationLink?.next else {
            return
        }
        
        // 検索開始
        asyncRepos = .loadingMore(asyncRepos.values)
        searchTask = Task {
            do {
                let response = try await GitHubAPIClient.shared.searchRepos(searchText: nextLink.searchText, page: nextLink.page)
                withAnimation {
                    asyncRepos = .loaded(asyncRepos.values + response.items)
                }
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
    
    func handleSortedByChanged() {
        
        // 検索済み以外は何もしない
        // 有効な検索結果がなければ何もしない
        // リンク情報がなければ何もしない(TODO: 見直せるかも)
        guard case .loaded = asyncRepos,
              !asyncRepos.values.isEmpty,
              let nextLink = relationLink?.next
        else {
            return
        }

        asyncRepos = .loading(asyncRepos.values)
        searchTask = Task {
            do {
                let response = try await GitHubAPIClient.shared.searchRepos(searchText: nextLink.searchText, sortedBy: sortedBy)
                withAnimation {
                    asyncRepos = .loaded(response.items)
                }
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
}
