//
//  SearchReposSuggestionStore.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/08.
//

import Foundation

@MainActor
@Observable
final class SearchReposSuggestionStore: SearchReposSuggestionStoreProtocol {
    
    // MARK: - Property
    
    static let shared: SearchReposSuggestionStore = .init()
    let userDefaults: UserDefaults?
    var histories: [String] = []
    
    // MARK: - LifeCycle
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        fetchValues()
    }
}
