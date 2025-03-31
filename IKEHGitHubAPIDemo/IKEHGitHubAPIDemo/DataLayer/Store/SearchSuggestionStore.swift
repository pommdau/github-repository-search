//
//  SearchSuggestionRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2024/11/13.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import SwiftUI

// MARK: -


@MainActor
@Observable
class SearchSuggestionStore {
    
    // MARK: - Property
            
    private static let maxHistoryCount = 5 // 履歴の最大記憶数
    static let recommendedSuggestions = ["SwiftUI", "Swift", "Python", "Apple", "Qiita"] // 固定のオススメ
    
    static let shared: SearchSuggestionStore = .init()
    
    var historySuggestions: [String] {
        didSet {
            UserDefaults.standard.setCodableItem(historySuggestions, forKey: "suggestions-history")
        }
    }
    
    // MARK: - LifeCycle
    
    private init() {
        // 保存されている値の読込
        self.historySuggestions = UserDefaults.standard.codableItem(forKey: "suggestions-history") ?? []
    }
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
