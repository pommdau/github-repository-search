//
//  RepoStore.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/29.
//

import Foundation
import SwiftUI

@MainActor @Observable
final class RepoStore {
    
    // MARK: - Property
    
    static let shared: RepoStore = .init()

    let repository: RepoRepositoryProtocol
    var values: [Repo] = []
    
    // MARK: - LifeCycle

    init(repository: RepoRepositoryProtocol) {
        self.repository = repository
    }
    
    convenience init() {
        self.init(repository: RepoRepository.shared)
    }

    // MARK: - CRUD

    // MARK: Create/Update

    func addValue(_ value: Repo) async throws {
        try await repository.addValue(value)
        withAnimation {
            if let index = values.firstIndex(where: { $0.id == value.id }) {
                values[index] = value // Update
            } else {
                values.append(value) // Create
            }
        }
    }
    
    func addValues(_ newValues: [Repo]) async throws {
        try await repository.addValues(values)
        withAnimation {
            for newValue in newValues {
                if let index = values.firstIndex(where: { $0.id == newValue.id }) {
                    values[index] = newValue // Update
                } else {
                    values.append(newValue) // Create
                }
            }
        }
    }
    
    // MARK: Read
    
    func fetchValues() async throws {
        let values = try await repository.fetchAllValues()
        withAnimation {
            self.values = values
        }
    }
    
    // MARK: Delete
    
    func deleteAllValues() async throws {
        try await repository.deleteAllValues()
        withAnimation {
            values.removeAll()
        }
    }
    
}
