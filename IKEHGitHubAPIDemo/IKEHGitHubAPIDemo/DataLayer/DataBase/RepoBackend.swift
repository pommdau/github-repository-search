//
//  RepoBackend.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/28.
//

import Foundation

final actor RepoBackend: BackendProtocol {
    typealias Item = Repo
    static let shared: RepoBackend = .init()
}

//final actor RepoBackendMock: BackendProtocol {
//    
//    typealias Item = Repo
//    static let shared: RepoBackendMock = .init()
//    
//    func addValue(_ value: Item) async throws {
//        
//    }
//    func addValues(_ values: [Item]) async throws {
//        
//    }
//    func fetchValue(for id: Item.ID) async throws -> Item? {
//        Repo.Mock.random()
//    }
//    func fetchValues(for ids: [Item.ID]) async throws -> [Item] {
//        Repo.Mock.random(count: 5)
//    }
//    func deleteValue(for id: Item.ID) async throws {
//        
//    }
//    func deleteValues(for ids: [Item.ID]) async throws {
//        
//    }
//    func deleteAll() async throws {
//        
//    }
//}
