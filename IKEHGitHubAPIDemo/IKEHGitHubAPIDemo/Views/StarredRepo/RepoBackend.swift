//
//  RepoBackend.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/28.
//

import Foundation

protocol RepoBackendProtocol: Actor {
    func add(_ repo: Repo, modified: Bool) async throws
    func read(for ids: [Repo.ID]) async throws -> [Repo]
    func readAll() async throws -> [Repo]
    func delete(for ids: [Repo.ID]) async throws
    func deleteAll() async throws
}


/// 本来はRealmやCoreDataの想定で、今回は簡易的にUserDefaultsとする
final actor RepoBackend: RepoBackendProtocol {
        
    private var reposUserDefaultsKey: String {
        let className = String(describing: type(of: self))
        return "\(className)-repos"
    }
        
    private var repos: [Repo] {
        get {
            guard let repos: [Repo] = UserDefaults.standard.codableItem(forKey: reposUserDefaultsKey) else {
                return []
            }
            return repos
        }
        set {
            UserDefaults.standard.setCodableItem(newValue, forKey: reposUserDefaultsKey)
        }
    }
    
    // MARK: - CRUD
    
    // MARK: - Create/Update
        
    func add(_ repo: Repo, modified: Bool = true) async throws {
        if let index = repos.firstIndex(where: { $0.id == repo.id }) {
            // 既に登録されている場合
            if modified {
                repos[index] = repo // Update
            } else {
                // 上書きを許可しない場合
                throw RepoBackendError.writeFailed("Already registered")
            }
        } else {
            repos.append(repo) // Create
        }
    }
    
    // MARK: Read
    
    func read(for ids: [Repo.ID]) async throws -> [Repo] {
        return repos.filter { ids.contains($0.id) }
    }
    
    func readAll() async throws -> [Repo] {
        return repos
    }
    
    // MARK: Delete
    
    func delete(for ids: [Repo.ID]) async throws {
        repos.removeAll(where: { ids.contains($0.id) })
    }
    
    func deleteAll() async throws {
        repos.removeAll()
    }
}

// MARK: Backend+Error

enum RepoBackendError: Error {
    case writeFailed(String)
    case readFailed(String)
}

extension RepoBackendError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .writeFailed(let message):
            return "Backend Write Failed: \(message)"
        case .readFailed(let message):
            return "Bacnend Read Failed: \(message)"
        }
    }
}
