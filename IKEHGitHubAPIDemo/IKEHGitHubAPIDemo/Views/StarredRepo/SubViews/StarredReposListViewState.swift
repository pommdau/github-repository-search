//
//  StarredRepoListView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/02.
//

import SwiftUI

@MainActor @Observable
final class StarredReposListViewState {
    
    let asyncRepos: AsyncValues<Repo, Error>
    
    var showNoResultView: Bool {
        // 検索結果が0であることが前提
        if !asyncRepos.values.isEmpty {
            return false
        }
        
        // 検索済み or エラーのとき
        switch asyncRepos {
        case .loaded, .error:
            return true
        default:
            return false
        }
    }
    
    init(asyncRepos: AsyncValues<Repo, Error>) {
        self.asyncRepos = asyncRepos
    }
}
