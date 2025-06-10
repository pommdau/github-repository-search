//
//  SearchReposSuggestionStoreStub.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/13.
//

import Foundation

@MainActor
@Observable
final class SearchReposSuggestionStoreStub: SearchReposSuggestionStoreProtocol {
    
    // MARK: - Property
    
    let userDefaults: UserDefaults? = nil
    var histories: [String] = []
    
    // MARK: - LifeCycle
    
    init(histories: [String] = []) {
        self.histories = histories
    }
}
