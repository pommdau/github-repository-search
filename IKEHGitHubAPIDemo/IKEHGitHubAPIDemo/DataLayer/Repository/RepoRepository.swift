//
//  RepoRepository.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/28.
//

import Foundation

final class RepoRepository: RepositoryProtocol, Sendable {
    
    typealias Item = Repo
    typealias Backend = RepoBackend
    
    static let shared: RepoRepository = .init()
    let backend: RepoBackend
    
    init(backend: RepoBackend) {
        self.backend = backend
    }
    
    convenience init() {
        self.init(backend: .shared)
    }
    
}
