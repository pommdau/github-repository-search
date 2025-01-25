//
//  StarredUserStore.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/25.
//

import SwiftUI

// MARK: - Store

@MainActor @Observable
final class StarredRepoStore {
    
    static let shared: StarredRepoStore = .init()
    
    private(set) var values: [Repo] = []
    let repository: StarredRepoRepository
    
    init(userRepository: StarredRepoRepository = .shared) {
        self.repository = userRepository
    }
    
    // MARK: - CRUD

    // MARK: Create
    
    func addValue(_ value: Repo) async throws {
        try await repository.addValue(value)
        withAnimation {
            self.values.append(value)
        }
    }

    // MARK: Read
    
    func loadAllValues() async throws  {
        let values = try await repository.fetchAllValues()
        withAnimation {
            self.values = values
        }
    }

    // MARK: Update
    
    func updateValue(_ newValue: Repo) async throws {
        guard let index = values.firstIndex(where: { $0.id == newValue.id }) else {
            return
        }
        try await repository.updateValue(newValue)
        withAnimation {
            values[index] = newValue
        }
    }

    // MARK: Delete
    
    func deleteValue(_ repo: Repo) async throws {
        guard let index = values.firstIndex(where: { $0.id == repo.id }) else {
            return
        }
        try await repository.deleteValues(for: [repo.id])
        withAnimation {
            _ = values.remove(at: index)
        }
    }
    
    func deleteValues(_ repos: [Repo]) async throws {
        let deleteUserIDs = repos.map { $0.id }
        try await repository.deleteValues(for: deleteUserIDs)
        withAnimation {
            values.removeAll(where: { deleteUserIDs.contains($0.id) })
        }
    }
}
