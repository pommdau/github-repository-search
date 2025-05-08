//
//  SearchReposSuggestionStore.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/08.
//

import SwiftUI

@MainActor
@Observable
final class SearchReposSuggestionStore: SearchReposSuggestionStoreProtocol {
    
    static let shared: SearchReposSuggestionStore = .init()
    
    var userDefaults: UserDefaults
    
    var histories: [String] {
        didSet {
            userDefaults.setCodableItem(histories, forKey: UserDefaults.Key.SearchReposSuggestionStore.histories)
        }
    }
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        // 保存されている値の読込
        self.histories = userDefaults.codableItem(forKey: UserDefaults.Key.SearchReposSuggestionStore.histories) ?? []

    }
}
