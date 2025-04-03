//
//  RepoStore.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/29.
//

import SwiftUI

@MainActor
@Observable
final class RepoStore: RepoStoreProtocol {
    static var shared: RepoStore = .init()
    var repository: RepoRepository?
    var valuesDic: [Repo.ID: Repo] = [:]
    
    // MARK: - LifeCycle
    
    init(repository: RepoRepository = .shared) {
        self.repository = repository
        Task {
            try? await self.fetchValues()
        }
    }
}
