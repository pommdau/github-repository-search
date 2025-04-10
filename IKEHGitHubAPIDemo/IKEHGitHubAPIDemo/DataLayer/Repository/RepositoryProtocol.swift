//
//  RepositoryProtocol.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/31.
//

import Foundation

protocol RepositoryProtocol {
    
    associatedtype Item: Identifiable & Codable & Sendable where Item.ID: Codable & Sendable
    associatedtype Backend: BackendProtocol where Backend.Item == Item
    var backend: Backend { get }
    
    // MARK: CRUD
    func addValue(_ value: Item) async throws
    func addValues(_ values: [Item]) async throws
    func fetchValue(for id: Item.ID) async throws -> Item?
    func fetchValues(for ids: [Item.ID]) async throws -> [Item]
    func fetchValuesAll() async throws -> [Item]
    func deleteValue(for id: Item.ID) async throws
    func deleteValues(for ids: [Item.ID]) async throws
    func deleteAll() async throws
}
