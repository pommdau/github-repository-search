//
//  SearchSuggestionRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2024/11/13.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import SwiftUI

@MainActor
@Observable
final class SearchSuggestionStore: SearchSuggestionStoreProtocol {
    
    static let shared: SearchSuggestionStore = .init()
    
    var userDefaults: UserDefaults
    
    var historySuggestions: [String] {
        didSet {
            userDefaults.setCodableItem(historySuggestions, forKey: "suggestions-history")
        }
    }
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        // 保存されている値の読込        
        self.historySuggestions = userDefaults.codableItem(forKey: "suggestions-history") ?? []

    }
}
