//
//  RepoStore.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/29.
//

import SwiftUI

@MainActor
@Observable
final class RepoStore {
    
    // MARK: - Property
    
    static let shared: RepoStore = .init()

    let repository: RepoRepository
    var valuesDic: [Repo.ID: Repo] = [:]
    
    var repos: [Repo] {
        Array(valuesDic.values)
    }
    
    // MARK: - LifeCycle

    init(repository: RepoRepository) {
        self.repository = repository
    }
    
    convenience init() {
        self.init(repository: RepoRepository.shared)
    }

    // MARK: - CRUD

    // MARK: Create/Update

    func addValue(_ value: Repo, updateStarred: Bool) async throws {
        let values = Repo.mergeRepos(
            existingRepos: Array(valuesDic.values),
            newRepos: [value],
            updateStarred: updateStarred
        )
        guard let value = values.first else {
            assertionFailure()
            return
        }
        
        try await repository.addValue(value)
        valuesDic[value.id] = value
    }
    
    func addValues(_ values: [Repo], updateStarred: Bool) async throws {
        let values = Repo.mergeRepos(
            existingRepos: Array(valuesDic.values),
            newRepos: values,
            updateStarred: updateStarred
        )
        try await repository.addValues(values)
        let newValuesDic = Dictionary(uniqueKeysWithValues: values.map { ($0.id, $0) })
        valuesDic.merge(newValuesDic) { _, new in new }
    }
    
    // MARK: Read
    
    func fetchValues() async throws {
        let values = try await repository.fetchValuesAll()
        valuesDic = Dictionary(uniqueKeysWithValues: values.map { ($0.id, $0) }) // Array -> Dictionary
    }

    // MARK: Delete

    func deleteAllValues() async throws {
        try await repository.deleteAll()
        valuesDic.removeAll()
    }
    
}
