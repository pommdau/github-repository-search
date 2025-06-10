//
//  RepoRepository.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import Foundation
import struct IKEHGitHubAPIClient.Repo

/// Repo型のRepository
final class RepoRepository: RepositoryProtocol, Sendable {
        
    // MARK: - 型の指定
    
    typealias Item = Repo
    typealias Backend = RepoBackend
    
    // MARK: - Property
            
    static let shared: RepoRepository = .init()
    let backend: RepoBackend
    
    // MARK: - LifeCycle
    
    init(backend: RepoBackend = .shared) {
        self.backend = backend
    }
}
