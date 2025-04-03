//
//  RepoStoreStub.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/04/03.
//

import Foundation

@MainActor
@Observable
final class RepoStoreStub: RepoStoreProtocol {
    static var shared: RepoStoreStub = .init()
    private(set) var repository: RepoRepository?
    var valuesDic: [Repo.ID: Repo] = [:]
    
    // MARK: - LifeCycle
    
    init() {}
}
