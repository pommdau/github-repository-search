//
//  RepoRepository.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/28.
//

import Foundation

final class RepoRepository: RepositoryProtocol, Sendable {
        
    // MARK: - 型の指定
    
    typealias Item = Repo
    typealias Backend = RepoBackend
    
    // MARK: - Property
            
    static let shared: RepoRepository = .init()    
    let backend: RepoBackend
    
    // MARK: - LifeCycle
    
    init(backend: RepoBackend) {
        self.backend = backend
    }
    
    convenience init() {
        self.init(backend: .shared)
    }
    
}
