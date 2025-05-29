//
//  BackendProtocol.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/31.
//

import Foundation

/// Backendの汎用型
/// - Note: 本来はRealmSwiftやCoreDataの想定で、今回は簡易的にUserDefaultsとする
/// - SeeAlso: [chatwork/svvs-sample](https://github.com/chatwork/svvs-sample)
protocol BackendProtocol: Actor {
    associatedtype Item: Identifiable & Codable where Item.ID: Codable & Sendable
    var userDefaults: UserDefaults? { get }
    func addValue(_ value: Item) async throws
    func addValues(_ values: [Item]) async throws
    func fetchValue(for id: Item.ID) async throws -> Item?
    func fetchValues(for ids: [Item.ID]) async throws -> [Item]
    func deleteValue(for id: Item.ID) async throws
    func deleteValues(for ids: [Item.ID]) async throws
    func deleteAll() async throws
}

extension BackendProtocol {
    
    private var valuesUserDefaultsKey: String {
        let className = String(describing: type(of: self))
        return "\(className)-values"
    }
        
    private var values: [Item.ID: Item] {
        get {
            guard let values: [Item.ID: Item] = userDefaults?.codableItem(forKey: valuesUserDefaultsKey) else {
                return [:]
            }
            return values
        }
        set {
            userDefaults?.setCodableItem(newValue, forKey: valuesUserDefaultsKey)
        }
    }
    
    // MARK: - CRUD
    
    // MARK: Create/Update
        
    func addValue(_ value: Item) async throws {
        values[value.id] = value
    }
    
    func addValues(_ values: [Item]) async throws {
        values.forEach { self.values[$0.id] = $0 }
    }
    
    // MARK: Read
    
    func fetchValue(for id: Item.ID) async throws -> Item? {
        return values[id]
    }
    
    func fetchValues(for ids: [Item.ID]) async throws -> [Item] {
        return ids.compactMap { values[$0] }
    }
    
    func fetchValuesAll() async throws -> [Item] {
        return Array(values.values)
    }

    // MARK: Delete
    
    func deleteValue(for id: Item.ID) async throws {
        values.removeValue(forKey: id)
    }
            
    func deleteValues(for ids: [Item.ID]) async throws {
        ids.forEach { values.removeValue(forKey: $0) }
    }
    
    func deleteAll() async throws {
        values.removeAll()
    }
}
