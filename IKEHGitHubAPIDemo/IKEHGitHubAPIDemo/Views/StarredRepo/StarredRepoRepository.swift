//
//  StarredBackend.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/25.
//

import Foundation

// MARK: - DataBase

final class StarredRepoRepository: Sendable {
        
    static let shared: StarredRepoRepository = .init()
    
    let backend: StarredUserBackend
    
    init(backend: StarredUserBackend = .shared) {
        self.backend = backend
    }
    
    // MARK: - CRUD

    // MARK: Create
    
    func addValue(_ value: Repo) async throws {
        try await backend.add(value)
    }
    
    // MARK: Read
    
    func fetchValue(for ids: [User.ID]) async throws -> [Repo] {
        return try await backend.read(for: ids)
    }
    
    func fetchAllValues() async throws -> [Repo] {
        try await backend.readAll()
    }
    
    // MARK: Update
        
    func updateValue(_ value: Repo) async throws {
        try await backend.add(value)
    }
    
    // MARK: Delete
    
    func deleteValues(for ids: [Repo.ID]) async throws {
        try await backend.delete(for: ids)
    }
}


// 今回はRealmSwiftやCoreDataの代わりにUserDefaultsを使用
final actor StarredUserBackend {
    
    static let shared: StarredUserBackend = .init()
    
    private var valuesUserDefaultsKey: String {
        let className = String(describing: type(of: self))
        return "\(className)-values"
    }
        
    var values: [Repo] {
        get {
            guard let values: [Repo] = UserDefaults.standard.codableItem(forKey: valuesUserDefaultsKey) else {
                return []
            }
            return values
        }
        set {
            UserDefaults.standard.setCodableItem(newValue, forKey: valuesUserDefaultsKey)
        }
    }
    
    // MARK: - CRUD
    
    // MARK: - Create/Update
    
    // RealmSwiftのようなmodifiedフラグを引数に持たせても良さそう
    func add(_ value: Repo) async throws {
        if let index = values.firstIndex(where: { $0.id == value.id }) {
            values[index] = value // Update
        } else {
            values.append(value) // Create
        }
    }
    
    // MARK: Read
        
    func read(for ids: [Repo.ID]) async throws -> [Repo] {
        return values.filter { ids.contains($0.id) }
    }
    
    func readAll() async throws -> [Repo] {
        return values
    }
    
    // MARK: Delete
    
    func delete(for ids: [Repo.ID]) async throws {
        values.removeAll(where: { ids.contains($0.id) })
    }
}

// MARK: Backend+Error

/*
enum BackendError: Error {
    case writeFailed(String)
    case readFailed(String)
}

extension BackendError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .writeFailed(let message):
            return "Backend Write Failed: \(message)"
        case .readFailed(let message):
            return "Bacnend Read Failed: \(message)"
        }
    }
}
*/
