//
//  RepoStoreProtocol.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/04/03.
//

import Foundation

@MainActor
protocol RepoStoreProtocol: AnyObject {
    static var shared: Self { get } // シングルトン
    var repository: RepoRepository? { get }
    var valuesDic: [Repo.ID: Repo] { get set } // TODO: Rename
}

extension RepoStoreProtocol {
    
    // MARK: - Property
    
    var repos: [Repo] {
        Array(valuesDic.values)
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
        
        try await repository?.addValue(value)
        valuesDic[value.id] = value
    }
    
    func addValues(_ values: [Repo], updateStarred: Bool) async throws {
        let values = Repo.mergeRepos(
            existingRepos: Array(valuesDic.values),
            newRepos: values,
            updateStarred: updateStarred
        )
        try await repository?.addValues(values)
        let newValuesDic = Dictionary(uniqueKeysWithValues: values.map { ($0.id, $0) })
        valuesDic.merge(newValuesDic) { _, new in new }
    }
    
    // MARK: Read
    
    func fetchValues() async throws {
        guard let repository else {
            return
        }
        let values = try await repository.fetchValuesAll()
        valuesDic = Dictionary(uniqueKeysWithValues: values.map { ($0.id, $0) }) // Array -> Dictionary
    }

    // MARK: Delete

    func deleteAllValues() async throws {
        try await repository?.deleteAll()
        valuesDic.removeAll()
    }
}
