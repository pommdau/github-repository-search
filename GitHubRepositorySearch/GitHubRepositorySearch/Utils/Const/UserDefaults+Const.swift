//
//  UserDefaults+Const.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import Foundation

extension UserDefaults {
    enum Key {}
}

extension UserDefaults.Key {
    enum LoginUserStore {
        static let loginUser = "loginUser"
    }
    
    enum RootTabViewState {
        static let selectedTab = "selectedTab"
    }
}
