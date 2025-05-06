//
//  RepoStore.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import Foundation
//import SwiftUI
import IKEHGitHubAPIClient

@MainActor
@Observable
final class RepoStore: RepoStoreProtocol {
    static var shared: RepoStore = .init()
    var repository: RepoRepository?
    var valuesDic: [SwiftID<Repo>: Repo] = [:]
    
    // MARK: - LifeCycle
    
    init(repository: RepoRepository? = .shared) {
        self.repository = repository
        Task {
            try? await self.fetchValues()
        }
    }
}
