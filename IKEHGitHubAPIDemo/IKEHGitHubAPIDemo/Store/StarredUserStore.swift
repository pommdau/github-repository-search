////
////  StarredUserStore.swift
////  IKEHGitHubAPIDemo
////
////  Created by HIROKI IKEUCHI on 2025/01/25.
////
//
import Foundation
//
//@MainActor @Observable
//final class StarredUserStore {
//    
//    static let shared: UserStore = .init()
//    
//    private(set) var values: [User] = []
//    let userRepository: UserRepository
//    
//    init(userRepository: UserRepository = .shared) {
//        self.userRepository = userRepository
//    }
//    
//    // MARK: - CRUD
//
//    // MARK: Create
//    
//    func addValue(_ user: User) async throws {
//        try await userRepository.addValue(user)
//        withAnimation {
//            self.values.append(user)
//        }
//    }
//
//    // MARK: Read
//    
//    func loadAllValues() async throws  {
//        let values = try await userRepository.fetchAllValues()
//        withAnimation {
//            self.values = values
//        }
//    }
//
//    // MARK: Update
//    
//    func updateValue(_ newValue: User) async throws {
//        guard let index = values.firstIndex(where: { $0.id == newValue.id }) else {
//            return
//        }
//        try await userRepository.updateValue(newValue)
//        withAnimation {
//            values[index] = newValue
//        }
//    }
//
//    // MARK: Delete
//    
//    func deleteValue(_ user: User) async throws {
//        guard let index = values.firstIndex(where: { $0.id == user.id }) else {
//            return
//        }
//        try await userRepository.deleteValues(for: [user.id])
//        withAnimation {
//            _ = values.remove(at: index)
//        }
//    }
//    
//    func deleteValues(_ users: [User]) async throws {
//        let deleteUserIDs = users.map { $0.id }
//        try await userRepository.deleteValues(for: deleteUserIDs)
//        withAnimation {
//            values.removeAll(where: { deleteUserIDs.contains($0.id) })
//        }
//    }
//}


// MARK: - DataBase

final class UserRepository: Sendable {
        
    static let shared: UserRepository = .init()
    
    let backend: Backend
        
    init(backend: Backend = .shared) {
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

final actor Backend {
    
    typealias Item = User
    
    static let shared: Backend = .init()
    
    private var itemsUserDefaultsKey: String {
        let className = String(describing: type(of: self))
        return "\(className)-items"
    }
        
    // 今回はRealmSwiftやCoreDataの代わりにUserDefaultsを使用
    var items: [Item] {
        get {
            guard let items: [Item] = UserDefaults.standard.codableItem(forKey: itemsUserDefaultsKey) else {
                return []
            }
            return items
        }
        set {
            UserDefaults.standard.setCodableItem(newValue, forKey: itemsUserDefaultsKey)
        }
    }
    
    // MARK: - CRUD
    
    // MARK: - Create/Update
    
    // RealmSwiftのようなmodifiedフラグを引数に持たせても良さそう
    func add(_ item: Item) async throws {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item // Update
        } else {
            items.append(item) // Create
        }
    }
    
    // MARK: Read
        
    func read(for ids: [Item.ID]) async throws -> [Item] {
        return items.filter { ids.contains($0.id) }
    }
    
    func readAll() async throws -> [User] {
        return items
    }
    
    // MARK: Delete
    
    func delete(for ids: [Item.ID]) async throws {
        items.removeAll(where: { ids.contains($0.id) })
    }
}

// MARK: Backend+Error

enum BackendError: Error, Sendable {
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
