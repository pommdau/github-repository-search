//
//  UserDefaults+Const.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import Foundation

extension UserDefaults {
    /// UserDefaultsのキーの定数値の定義
    enum Key {}
}

extension UserDefaults.Key {
    enum LoginUserStore {
        static let loginUser = "LoginUserStore-loginUser"
    }
        
    enum SearchReposSuggestionStore {
        static let histories = "SearchReposSuggestionStore-histories"
    }
    
    enum RootTabViewState {
        static let selectedTab = "RootTabViewState-selectedTab"
    }
    
    enum SearchReposViewState {
        static let sortedBy = "RootTabViewState-sortedBy"
    }
}
