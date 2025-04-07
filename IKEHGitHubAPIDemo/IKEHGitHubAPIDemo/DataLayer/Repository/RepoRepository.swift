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
    
    init(backend: RepoBackend = .shared) {
        self.backend = backend
    }    
}

// MARK: - CRUD

extension RepoRepository {
        
    // MARK: Create / Update
        
    func addValue(_ value: Item) async throws {
        try await backend.addValue(value)
    }
    func addValues(_ values: [Item]) async throws {
        try await backend.addValues(values)
    }
    
    // MARK: Read

    func fetchValue(for id: Item.ID) async throws -> Item? {
        try await backend.fetchValue(for: id)
    }
    func fetchValues(for ids: [Item.ID]) async throws -> [Item] {
        try await backend.fetchValues(for: ids)
    }
    func fetchValuesAll() async throws -> [Item] {
        try await backend.fetchValuesAll()
    }
    
    // MARK: Delete
    
    func deleteValue(for id: Item.ID) async throws {
        try await backend.deleteValue(for: id)
    }
    func deleteValues(for ids: [Item.ID]) async throws {
        try await backend.deleteValues(for: ids)
    }
    func deleteAll() async throws {
        try await backend.deleteAll()
    }
}
