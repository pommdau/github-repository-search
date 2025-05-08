//
//  StarredRepoStoreProtocol.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/07.
//

import Foundation
import IKEHGitHubAPIClient

@MainActor
protocol StarredRepoStoreProtocol: AnyObject {
    static var shared: Self { get }
    var repository: StarredRepoRepository? { get }
    var valuesDic: [SwiftID<StarredRepo>: StarredRepo] { get set }
}

extension StarredRepoStoreProtocol {
    
    // MARK: - Property
    
    var repos: [StarredRepo] {
        Array(valuesDic.values)
    }
    
    // MARK: - CRUD

    // MARK: Create/Update

    func addValue(_ value: StarredRepo) async throws {
        try await addValues([value])
    }
    
    func addValues(_ values: [StarredRepo]) async throws {
        try await repository?.addValues(values)
        let newValuesDic = Dictionary(
            uniqueKeysWithValues: values.map { value in
                (value.id, value)
            })
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
