//
//  StarredRepoRepository.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/07.
//

import Foundation

final class StarredRepoRepository: RepositoryProtocol, Sendable {
        
    // MARK: - 型の指定
    
    typealias Item = StarredRepo
    typealias Backend = StarredRepoBackend
    
    // MARK: - Property
            
    static let shared: StarredRepoRepository = .init()
    let backend: StarredRepoBackend
    
    // MARK: - LifeCycle
    
    init(backend: StarredRepoBackend = .shared) {
        self.backend = backend
    }
}
