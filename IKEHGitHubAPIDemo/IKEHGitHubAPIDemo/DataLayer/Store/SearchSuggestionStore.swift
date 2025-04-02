//
//  SearchSuggestionRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2024/11/13.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import SwiftUI

@MainActor
protocol SearchSuggestionStoreProtocol: AnyObject {
    var maxHistoryCount: Int { get } // 履歴の最大記憶数
    var recommendedSuggestions: [String] { get } // アプリ側で固定のレコメンド
//    var shared: Self { get }
    var historySuggestions: [String] { get set } // 検索履歴
    
    
    func addHistory(_ keyword: String)
    func removeAllHistories()
}

extension SearchSuggestionStoreProtocol {
    
    var maxHistoryCount: Int {
        5
    }
    
    var recommendedSuggestions: [String] {
        ["SwiftUI", "Swift", "Python", "Apple", "Qiita"]
    }
//    let shared: SearchSuggestionStore = .init()
            
//    var historySuggestions: [String] {
//        didSet {
//            userDefaults?.setCodableItem(historySuggestions, forKey: "suggestions-history")
//        }
//    }
    
    // MARK: - 履歴の追加/削除
    
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
        while historySuggestions.count > maxHistoryCount {
            historySuggestions.removeLast()
        }
    }
        
    func removeAllHistories() {
        historySuggestions.removeAll()
    }
}

@MainActor
@Observable
class NewSearchSuggestionStore: SearchSuggestionStoreProtocol {
    
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

@MainActor
@Observable
final class NewSearchSuggestionStoreMock: SearchSuggestionStoreProtocol {
    
    let userDefaults: UserDefaults? = nil
    var historySuggestions: [String]
    
    init(historySuggestions: [String] = []) {
        self.historySuggestions = historySuggestions
    }
}

// MARK: -

@MainActor
@Observable
class SearchSuggestionStore {
    
    // MARK: - Property
            
    private static let maxHistoryCount = 5 // 履歴の最大記憶数
    static let recommendedSuggestions = ["SwiftUI", "Swift", "Python", "Apple", "Qiita"] // 固定のオススメ
    static let shared: SearchSuggestionStore = .init()
    
    var userDefaults: UserDefaults?
    
    var historySuggestions: [String] {
        didSet {
            userDefaults?.setCodableItem(historySuggestions, forKey: "suggestions-history")
        }
    }
    
    // MARK: - LifeCycle
    
    private init(userDefaults: UserDefaults? = .standard) {
        self.userDefaults = userDefaults
        // 保存されている値の読込
        self.historySuggestions = userDefaults?.codableItem(forKey: "suggestions-history") ?? []
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
