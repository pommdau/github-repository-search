//
//  SearchScreenViewStateTest.swift
//  IKEHGitHubAPIDemoTests
//
//  Created by HIROKI IKEUCHI on 2025/03/28.
//

import XCTest
@testable import IKEHGitHubAPIDemo

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
        let urlSessionStub: URLSessionStub = .init()
        let tokenStoreStub: TokenStoreStub = .init()
        // クエリパラメータのcodeが不足しているURL

        let gitHubAPIClient = GitHubAPIClientStub()
        let repoStore = RepoStoreStub()
        let loginUserStore = LoginUserStoreStub()
        let searchSuggestionStore = SearchSuggestionStoreStub()
        
        sut = .init(
            gitHubAPIClient: gitHubAPIClient,
            repoStore: repoStore,
            loginUserStore: loginUserStore,
            searchSuggestionStore: searchSuggestionStore
        )
        

        // MARK: When
        // MARK: Then
        
    }
    
}
