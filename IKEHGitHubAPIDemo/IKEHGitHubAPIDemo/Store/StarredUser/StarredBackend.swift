//
//  StarredBackend.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/25.
//

import SwiftUI

// MARK: - Store

@MainActor @Observable
final class StarredUserStore {
    
    static let shared: StarredUserStore = .init()
    
    private(set) var values: [User] = []
    let repository: StarredUserRepository
    
    init(userRepository: StarredUserRepository = .shared) {
        self.repository = userRepository
    }
    
    // MARK: - CRUD

    // MARK: Create
    
    func addValue(_ user: User) async throws {
        try await repository.addValue(user)
        withAnimation {
            self.values.append(user)
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
    
    func updateValue(_ newValue: User) async throws {
        guard let index = values.firstIndex(where: { $0.id == newValue.id }) else {
            return
        }
        try await repository.updateValue(newValue)
        withAnimation {
            values[index] = newValue
        }
    }

    // MARK: Delete
    
    func deleteValue(_ user: User) async throws {
        guard let index = values.firstIndex(where: { $0.id == user.id }) else {
            return
        }
        try await repository.deleteValues(for: [user.id])
        withAnimation {
            _ = values.remove(at: index)
        }
    }
    
    func deleteValues(_ users: [User]) async throws {
        let deleteUserIDs = users.map { $0.id }
        try await repository.deleteValues(for: deleteUserIDs)
        withAnimation {
            values.removeAll(where: { deleteUserIDs.contains($0.id) })
        }
    }
}

// MARK: - DataBase

final class StarredUserRepository: Sendable {
        
    static let shared: StarredUserRepository = .init()
    
    let backend: StarredUserBackend
    
    init(backend: StarredUserBackend = .shared) {
        self.backend = backend
    }
    
    // MARK: - CRUD

    // MARK: Create
    
    func addValue(_ user: User) async throws {
        try await backend.add(user)
    }
    
    // MARK: Read
    
    func fetchValue(for ids: [User.ID]) async throws -> [User] {
        return try await backend.read(for: ids)
    }
    
    func fetchAllValues() async throws -> [User] {
        try await backend.readAll()
    }
    
    // MARK: Update
        
    func updateValue(_ user: User) async throws {
        try await backend.add(user)
    }
    
    // MARK: Delete
    
    func deleteValues(for ids: [User.ID]) async throws {
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
        
    var users: [User] {
        get {
            guard let users: [User] = UserDefaults.standard.codableItem(forKey: valuesUserDefaultsKey) else {
                return []
            }
            return users
        }
        set {
            UserDefaults.standard.setCodableItem(newValue, forKey: valuesUserDefaultsKey)
        }
    }
    
    // MARK: - CRUD
    
    // MARK: - Create/Update
    
    // RealmSwiftのようなmodifiedフラグを引数に持たせても良さそう
    func add(_ user: User) async throws {
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user // Update
        } else {
            users.append(user) // Create
        }
    }
    
    // MARK: Read
        
    func read(for ids: [User.ID]) async throws -> [User] {
        return users.filter { ids.contains($0.id) }
    }
    
    func readAll() async throws -> [User] {
        return users
    }
    
    // MARK: Delete
    
    func delete(for ids: [User.ID]) async throws {
        users.removeAll(where: { ids.contains($0.id) })
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
