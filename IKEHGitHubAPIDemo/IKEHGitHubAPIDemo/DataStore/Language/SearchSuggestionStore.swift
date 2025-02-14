//
//  SearchSuggestionRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2024/11/13.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct SearchSuggestionStore {
    
    // MARK: - Property

    private static let maxHistoryCount = 5
    static let shared: SearchSuggestionStore = .init()
    let recommendedSuggestions = ["SwiftUI", "Swift", "Python", "Apple", "Qiita"]
    
    // INFO: シングルトンでなくなった場合はIdentifiedなキーで保存すること
    @AppStorage("history-suggestions")
    var historySuggestions: [String] = []
    
    // MARK: - LifeCycle
    
    private init() {}
}

// MARK: - CRUD

extension SearchSuggestionStore {
    
    // MARK: Create
    
    func addHistory(_ keyword: String) {
        if keyword.isEmpty {
            return
        }
        // 履歴にある場合は最新になるように再配置
        if let index = historySuggestions.firstIndex(where: { $0 == keyword }) {
            historySuggestions.remove(at: index)
            historySuggestions.insert(keyword, at: 0)
            return
        }
        
        // 履歴になければ検索された語句を追加
        historySuggestions.insert(keyword, at: 0)
        
        // 履歴の上限を超えた分を古い順に削除
        while historySuggestions.count > Self.maxHistoryCount {
            historySuggestions.removeLast()
        }
    }
    
    // MARK: Delete
    
    func removeAllHistories() {
        historySuggestions.removeAll()
    }
}
