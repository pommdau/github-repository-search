//
//  SearchReposSuggestionStoreProtocol.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/08.
//

import Foundation

@MainActor
protocol SearchReposSuggestionStoreProtocol: AnyObject {
    var histories: [String] { get set } // 検索履歴
    var userDefaults: UserDefaults? { get }
}

// MARK: - Static Property

extension SearchReposSuggestionStoreProtocol {
    
    /// 履歴の最大記憶数
    static var maxHistory: Int {
        5
    }
    
    /// アプリ側で固定のレコメンド
    var recommendedSuggestions: [String] {
        ["SwiftUI", "Swift", "Python", "Apple", "Qiita"]
    }
}
 
// MARK: - CRUD

extension SearchReposSuggestionStoreProtocol {
    
    // MARK: Helpers
    
    /// 履歴の作成ロジック
    private static func createHistories(current histories: [String], newHistory: String) -> [String] {
        
        var histories = histories
        
        // 空の場合は保存しない
        if newHistory.isEmpty {
            return histories
        }
        // 履歴にある場合は最新になるように再配置
        if let index = histories.firstIndex(where: { $0 == newHistory }) {
            histories.remove(at: index)
            histories.insert(newHistory, at: 0)
            return histories
        }
        
        // 履歴になければ検索された語句を追加
        histories.insert(newHistory, at: 0)
        
        // 履歴の上限を超えた分を古い順に削除
        while histories.count > maxHistory {
            histories.removeLast()
        }
        
        return histories
    }

    // MARK: Create / Update
    
    func addValue(_ keyword: String) {
        histories = Self.createHistories(current: histories, newHistory: keyword)
        userDefaults?.setCodableItem(histories, forKey: UserDefaults.Key.SearchReposSuggestionStore.histories)
    }
                
    // MARK: Read
    
    /// 保存されている履歴を取得
    /// - Note: 初回のView表示時のラグをなくすためasyncにしている(他の原因もありえるので要観察)
    func loadValues() async {
        histories = userDefaults?.codableItem(forKey: UserDefaults.Key.SearchReposSuggestionStore.histories) ?? []
    }
        
    // MARK: Delete
    
    func removeValue(atOffsets offSets: IndexSet) {
        histories.remove(atOffsets: offSets)
        userDefaults?.setCodableItem(histories, forKey: UserDefaults.Key.SearchReposSuggestionStore.histories)
    }
        
    func removeAllValues() {
        histories.removeAll()
        userDefaults?.set(nil, forKey: UserDefaults.Key.SearchReposSuggestionStore.histories)
    }
}
