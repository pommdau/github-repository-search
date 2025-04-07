//
//  SearchSuggestionStoreTests.swift
//  IKEHGitHubAPIDemoTests
//
//  Created by HIROKI IKEUCHI on 2025/04/07.
//

import XCTest
import KeychainAccess
@testable import IKEHGitHubAPIDemo


@MainActor
final class SearchSuggestionStoreTests: XCTestCase {
    
    // MARK: - Property
    
    static let userDefaultsSuiteName = "SearchSuggestionStoreTests.UserDefaults"
    private let userDefaults = UserDefaults(suiteName: SearchSuggestionStoreTests.userDefaultsSuiteName)!
    private var sut: SearchSuggestionStore! // sut: System Under Test
            
    // MARK: - SetUp
    
    override func setUp() async throws {
        try await super.setUp()
        sut = SearchSuggestionStore(userDefaults: userDefaults)
    }
    
    // MARK: - Teardown
    
    override func tearDown() async throws {
        try await super.tearDown()
        sut = nil
        try UserDefaults.resetAndRemovePlistUserDefaults(suiteName: Self.userDefaultsSuiteName)
    }
}

// MARK: - Tests

extension SearchSuggestionStoreTests {
    
    /// Create/Updateのテスト
    func testAddHistory() async throws {
        
        // 空の場合は履歴に追加されない
        print(sut.historySuggestions)
        sut.addHistory("")
        XCTAssertEqual(sut.historySuggestions.count, .zero)

        // 履歴の追加
        let testHistories1 = (0..<sut.maxHistoryCount).map { _ in
            UUID().uuidString
        }
        testHistories1.forEach { testHistory in
            sut.addHistory(testHistory)
            XCTAssertEqual(sut.historySuggestions.first, testHistory) // 先頭に配置されていることの確認
        }
        XCTAssertEqual(sut.historySuggestions.count, testHistories1.count)
                    
        // すでに履歴にある場合、先頭に配置されることの確認
        let testHistory2 = UUID().uuidString
        sut.addHistory(testHistory2)
        XCTAssertEqual(sut.historySuggestions.first, testHistory2)
        
        // 履歴上限を超えた場合
        let testHistory3 = UUID().uuidString
        sut.addHistory(testHistory3)
        XCTAssertEqual(sut.historySuggestions.count, sut.maxHistoryCount)
        XCTAssertFalse(sut.historySuggestions.contains(testHistories1.first!)) // 最も古い履歴が削除されている
    }
    
    func testRemoveHistorySuccess() async throws {
        
        // MARK: Given
        
        // 履歴の追加
        let testHistories = (0..<sut.maxHistoryCount).map { _ in
            UUID().uuidString
        }
        testHistories.forEach { testHistory in
            sut.addHistory(testHistory)
        }
        
        // MARK: When
        
        print(sut.historySuggestions)
        sut.removeHistory(atOffsets: .init(integer: 0)) // 最新の履歴の削除
        print(sut.historySuggestions)
        // MARK: Then
        
        XCTAssertEqual(sut.historySuggestions.count, testHistories.count - 1) // 要素数の確認
        XCTAssertEqual(sut.historySuggestions.first, testHistories[sut.maxHistoryCount - 2]) // 最後から2番目に追加された履歴が先頭に来ていることの確認
    }
    
    func testRemoveAllHistoriesSuccess() async throws {
        
        // MARK: Given
        
        // 履歴の追加
        let testHistories = (0..<sut.maxHistoryCount).map { _ in
            UUID().uuidString
        }
        testHistories.forEach { testHistory in
            sut.addHistory(testHistory)
        }
        
        // MARK: When
        
        sut.removeAllHistories()
        
        // MARK: Then
        
        XCTAssertEqual(sut.historySuggestions.count, .zero)
    }
}
