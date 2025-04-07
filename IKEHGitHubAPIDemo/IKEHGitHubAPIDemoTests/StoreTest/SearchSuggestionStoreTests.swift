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
        
        // MARK: Given
        
        sut.addHistory("hoge")
        
        // 空の場合
        print(sut.historySuggestions)
        sut.addHistory("")
//        XCTAssertEqual(sut.historySuggestions.count, .zero)
//        
//        // 履歴の追加
//        for count in 0..<5 {
//            let newHistory = "\(count)"
//            sut.addHistory(newHistory)
//            XCTAssertEqual(sut.historySuggestions.first, newHistory)
//            XCTAssertEqual(sut.historySuggestions.count, count + 1)
//        }
        
        // 上限超えた場合
        
        
        //
        //        XCTAssertEqual(sut.valuesDic.count, 0)
        //
        //        // MARK: When
        //        let testRepos = Repo.Mock.random(count: 10)
        //        try await sut.addValues(testRepos, updateStarred: false)
        //
        //        // MARK: Then
        //        // 登録数の確認
        //        XCTAssertEqual(sut.valuesDic.count, testRepos.count)
    }
}
