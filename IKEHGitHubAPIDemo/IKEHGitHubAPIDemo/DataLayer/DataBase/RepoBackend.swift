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
