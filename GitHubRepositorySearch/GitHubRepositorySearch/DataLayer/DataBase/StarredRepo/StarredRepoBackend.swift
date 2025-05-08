//
//  StarredRepoBackend.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/07.
//

import Foundation

final actor StarredRepoBackend: BackendProtocol {
    typealias Item = StarredRepo
    static let shared: StarredRepoBackend = .init()
    var userDefaults: UserDefaults?
    
    init(userDefaults: UserDefaults? = .standard) {
        self.userDefaults = userDefaults
    }
}
