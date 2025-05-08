//
//  RepoBackend.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/28.
//

import Foundation
import struct IKEHGitHubAPIClient.Repo

final actor RepoBackend: BackendProtocol {
    typealias Item = Repo
    static let shared: RepoBackend = .init()
    var userDefaults: UserDefaults?
    
    init(userDefaults: UserDefaults? = .standard) {
        self.userDefaults = userDefaults
    }
}

