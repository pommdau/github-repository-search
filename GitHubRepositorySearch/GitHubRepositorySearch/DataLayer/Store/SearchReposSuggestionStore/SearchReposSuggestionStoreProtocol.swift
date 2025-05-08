//
//  SearchReposSuggestionStoreProtocol.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/08.
//

import SwiftUI

@MainActor
protocol SearchReposSuggestionStoreProtocol: AnyObject {
    var histories: [String] { get set } // 検索履歴
}

extension SearchReposSuggestionStoreProtocol {
    
    // MARK: - Property
    
    /// 履歴の最大記憶数
    var maxHistory: Int {
        5
    }
    
    /// アプリ側で固定のレコメンド
    var recommendedSuggestions: [String] {
        ["SwiftUI", "Swift", "Python", "Apple", "Qiita"]
    }
    
    // MARK: - CRUD
    
    func addValue(_ keyword: String) {
        if keyword.isEmpty {
            return
        }
        // 履歴にある場合は最新になるように再配置
        if let index = histories.firstIndex(where: { $0 == keyword }) {
            histories.remove(at: index)
            histories.insert(keyword, at: 0)
            return
        }
        
        // 履歴になければ検索された語句を追加
        histories.insert(keyword, at: 0)
        
        // 履歴の上限を超えた分を古い順に削除
        while histories.count > maxHistory {
            histories.removeLast()
        }
    }
    
    func removeValue(atOffsets offSets: IndexSet) {
        histories.remove(atOffsets: offSets)
    }
        
    func removeAllValues() {
        histories.removeAll()
    }
}
