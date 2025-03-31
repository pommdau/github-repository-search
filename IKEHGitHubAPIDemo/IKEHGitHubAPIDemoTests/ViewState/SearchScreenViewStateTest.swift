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
        let testLastLoginStateID = UUID().uuidString
        tokenStoreStub.lastLoginStateID = testLastLoginStateID
        // クエリパラメータのcodeが不足しているURL
        let testSessionCode = "adccb822dd897e2d470e"
        guard let testURL = URL(string: "ikehgithubapi://callback?code=\(testSessionCode)") else {
            fatalError("Failed to create URL")
        }
        
        
        let gitHubAPIClient = GitHubAPIClientStub()
        let loginUserStoreStub = LoginUserStoreStub()
        
//        sut = .init(
//            gitHubAPIClient: gitHubAPIClient,
//            repoStore: <#T##RepoStore#>,
//            loginUserStore: <#T##LoginUserStore#>,
//            searchSuggestionStore: SearchSuggestionStore()
//        )
        

        // MARK: When
        // MARK: Then
        
    }
    
}
