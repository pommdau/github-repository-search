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

    // MARK: Create

    func addValue(_ value: Repo) async throws {
        try await repository.addValue(value)
        withAnimation {
            values.append(value)
        }
    }
    
    func addValues(_ values: [Repo]) async throws {
        try await repository.addValues(values)
        withAnimation {
            self.values.append(contentsOf: values)
        }
    }
}
