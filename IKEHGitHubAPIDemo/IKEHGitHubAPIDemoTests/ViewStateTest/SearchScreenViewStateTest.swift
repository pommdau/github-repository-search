//
//  SearchScreenViewStateTest.swift
//  IKEHGitHubAPIDemoTests
//
//  Created by HIROKI IKEUCHI on 2025/03/28.
//

import XCTest
@testable import IKEHGitHubAPIDemo

@MainActor
final class SearchScreenViewStateTest: XCTestCase {
    
    // MARK: - Property
    
    private var sut: SearchScreenViewState!
    
    // MARK: - SetUp
    
    override func setUp() async throws {
        try await super.setUp()
    }
    
    // MARK: - Teardown
    
    override func tearDown() async throws {
        try await super.tearDown()
        sut = nil
    }
}

// MARK: - リポジトリの検索テスト

extension SearchScreenViewStateTest {
    
    // MARK: 成功
    @MainActor
    func testHandleSearchSuccess() async {
        
        // MARK: Given
        let gitHubAPIClientStub = GitHubAPIClientStub()
        let repoStoreStub = RepoStoreStub()
        let loginUserStoreStub = LoginUserStoreStub()
        let searchSuggestionStoreStub = SearchSuggestionStoreStub()
        
        sut = .init(
            gitHubAPIClient: gitHubAPIClientStub,
            repoStore: repoStoreStub,
            loginUserStore: loginUserStoreStub,
            searchSuggestionStore: searchSuggestionStoreStub
        )
                
        // MARK: When
        
        // MARK: 検索開始
        sut.searchText = "testText"
//        async let search: Void = sut.handleSearch()
        sut.handleSearch()
        
        switch sut.asyncRepos {
        case .loading:
            break
        default:
            XCTFail("unexpected repos: \(sut.asyncRepos)")
        }
        
        // APIの実行
                        
        // MARK: Then
        
    }
    
}
